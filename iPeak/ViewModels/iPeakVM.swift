//
//  iPeakVM.swift
//  iPeak
//
//  Created by Aayush Pokharel on 2021-12-14.
//

import Foundation
import SwiftUI

struct NetworkProcessClient: Sendable {
    var run: @Sendable (String) async -> String

    static let live = Self { command in
        await Task.detached(priority: .userInitiated) {
            ShellProcess.run(command)
        }.value
    }

    static let preview = Self { _ in "" }
}

private enum ShellProcess {
    static func run(_ command: String) -> String {
        let task = Process()
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        task.arguments = ["-c", command]

        do {
            try task.run()
        } catch {
            return ""
        }

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        task.waitUntilExit()

        return String(data: data, encoding: .utf8) ?? ""
    }
}

struct NetworkKeyValue: Equatable {
    var key: String
    var value: String
}

struct WiFiDetails: Equatable {
    var currentSignalStrength = 0
    var ssid = "unknown"
    var auth = "unknown"
    var state = "unknown"
    var mode = "station"
    var maxRate = 0
}

struct NetworkQualitySnapshot: Equatable {
    var currentUpload = "0 Mbps"
    var currentDownload = "0 Mbps"
    var uploadFlows = 0
    var downloadFlows = 0
    var responsiveness = "0 RPM"
}

enum NetworkInfoParser {
    static func keyValue<S: StringProtocol>(from line: S) -> NetworkKeyValue? {
        let cleanLine = String(line).trimmingCharacters(in: .whitespacesAndNewlines)
        guard let separator = cleanLine.firstIndex(of: ":") else { return nil }

        let key = cleanLine[..<separator].trimmingCharacters(in: .whitespaces)
        let valueStart = cleanLine.index(after: separator)
        let value = cleanLine[valueStart...].trimmingCharacters(in: .whitespaces)

        guard !key.isEmpty else { return nil }
        return NetworkKeyValue(key: key, value: value)
    }

    static func wifiDetails(from output: String) -> WiFiDetails {
        var details = WiFiDetails()

        for line in output.split(whereSeparator: \.isNewline) {
            guard let pair = keyValue(from: line) else { continue }

            switch pair.key {
            case "agrCtlRSSI":
                details.currentSignalStrength = Int(pair.value) ?? 0
            case "SSID":
                details.ssid = pair.value
            case "link auth":
                details.auth = pair.value
            case "state":
                details.state = pair.value
            case "op mode":
                details.mode = pair.value
            case "maxRate":
                details.maxRate = Int(pair.value) ?? 0
            default:
                break
            }
        }

        return details
    }

    static func networkQuality(from output: String) -> NetworkQualitySnapshot {
        var snapshot = NetworkQualitySnapshot()

        for line in output.split(whereSeparator: \.isNewline) {
            guard let pair = keyValue(from: line) else { continue }

            switch pair.key {
            case "Upload capacity":
                snapshot.currentUpload = pair.value
            case "Download capacity":
                snapshot.currentDownload = pair.value
            case "Upload flows":
                snapshot.uploadFlows = Int(pair.value) ?? 0
            case "Download flows":
                snapshot.downloadFlows = Int(pair.value) ?? 0
            case "Responsiveness":
                snapshot.responsiveness = pair.value
            default:
                break
            }
        }

        return snapshot
    }

    static func localIP(from output: String) -> String {
        output.replacingOccurrences(of: "\n", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

@MainActor
final class iPeakViewModel: ObservableObject {
    @Published var localIP: String = "0.0.0.0"
    @Published var currentSignalStrength: Int = 0
    @Published var signalStrengths: [Int] = [Int]()
    @Published var SSID: String = "unknown"
    @Published var auth: String = "unknown"
    @Published var wifiState: String = "unknown"
    @Published var mode: String = "station"
    @Published var maxRate: Int = 0
    @Published var ipv4: String = "0.0.0.0"
    @Published var ipv6: String = "0.0.0.0"
    @Published var isSpeedTestRunning: Bool = true
    @Published var currentUpload: String = "0 Mbps"
    @Published var currentDownload: String = "0 Mbps"
    @Published var uploadFlows: Int = 0
    @Published var downloadFlows: Int = 0
    @Published var responsiveness: String = "0 RPM"

    private let processClient: NetworkProcessClient

    init(processClient: NetworkProcessClient = .live) {
        self.processClient = processClient
    }

    func task() async {
        await refreshLocalIpDetails()
    }

    func refreshLocalIpDetails() async {
        let wifiOutput = await processClient.run(Self.airportCommand)
        let localIPOutput = await processClient.run(Self.localIPCommand)
        let details = NetworkInfoParser.wifiDetails(from: wifiOutput)

        currentSignalStrength = details.currentSignalStrength
        signalStrengths.append(details.currentSignalStrength)
        SSID = details.ssid
        auth = details.auth
        wifiState = details.state
        mode = details.mode
        maxRate = details.maxRate
        localIP = NetworkInfoParser.localIP(from: localIPOutput)
    }

    func speedTestViewAppeared() async {
        guard isSpeedTestRunning else { return }
        await runSpeedTest()
    }

    func restartButtonTapped() async {
        await runSpeedTest()
    }

    private func runSpeedTest() async {
        isSpeedTestRunning = true

        let shellOutput = await processClient.run("networkQuality")
        let snapshot = NetworkInfoParser.networkQuality(from: shellOutput)

        currentUpload = snapshot.currentUpload
        currentDownload = snapshot.currentDownload
        uploadFlows = snapshot.uploadFlows
        downloadFlows = snapshot.downloadFlows
        responsiveness = snapshot.responsiveness
        isSpeedTestRunning = false
    }

    private static let airportCommand = "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I"
    private static let localIPCommand = "ifconfig | grep \"inet \" | grep -Fv 127.0.0.1 | awk '{print $2}'"
}
