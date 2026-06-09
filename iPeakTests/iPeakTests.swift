//
//  iPeakTests.swift
//  iPeakTests
//
//  Created by Aayush Pokharel on 2021-12-14.
//

import XCTest
@testable import iPeak

@MainActor
final class iPeakTests: XCTestCase {

    func testKeyValueParserKeepsValuesContainingColons() {
        XCTAssertEqual(
            NetworkInfoParser.keyValue(from: " Upload capacity: 41.2 Mbps: validated "),
            NetworkKeyValue(key: "Upload capacity", value: "41.2 Mbps: validated")
        )
    }

    func testWiFiDetailsParser() {
        let output = """
             agrCtlRSSI: -56
                   SSID: Studio
              link auth: wpa2-psk
                  state: running
                op mode: station
                maxRate: 866
        """

        XCTAssertEqual(
            NetworkInfoParser.wifiDetails(from: output),
            WiFiDetails(
                currentSignalStrength: -56,
                ssid: "Studio",
                auth: "wpa2-psk",
                state: "running",
                mode: "station",
                maxRate: 866
            )
        )
    }

    func testNetworkQualityParser() {
        let output = """
        Upload capacity: 12.4 Mbps
        Download capacity: 91.8 Mbps
        Upload flows: 16
        Download flows: 20
        Responsiveness: High (143 RPM)
        """

        XCTAssertEqual(
            NetworkInfoParser.networkQuality(from: output),
            NetworkQualitySnapshot(
                currentUpload: "12.4 Mbps",
                currentDownload: "91.8 Mbps",
                uploadFlows: 16,
                downloadFlows: 20,
                responsiveness: "High (143 RPM)"
            )
        )
    }

    func testViewModelLoadsLocalIPDetailsWithInjectedProcessClient() async {
        let processClient = NetworkProcessClient { command in
            if command.contains("airport") {
                return """
                     agrCtlRSSI: -47
                           SSID: Lab
                      link auth: wpa3
                          state: running
                        op mode: station
                        maxRate: 1200
                """
            } else {
                return "192.168.1.4\n"
            }
        }

        let model = iPeakViewModel(processClient: processClient)
        await model.task()

        XCTAssertEqual(model.localIP, "192.168.1.4")
        XCTAssertEqual(model.currentSignalStrength, -47)
        XCTAssertEqual(model.signalStrengths, [-47])
        XCTAssertEqual(model.SSID, "Lab")
        XCTAssertEqual(model.auth, "wpa3")
        XCTAssertEqual(model.wifiState, "running")
        XCTAssertEqual(model.mode, "station")
        XCTAssertEqual(model.maxRate, 1200)
    }
}
