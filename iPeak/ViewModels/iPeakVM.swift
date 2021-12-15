//
//  iPeakVM.swift
//  iPeak
//
//  Created by Aayush Pokharel on 2021-12-14.
//

import SwiftUI



class iPeakViewModel: ObservableObject{
    //    MARK: - Local IP Details
    @Published var localIP: String = "0.0.0.0"
    // agrCtlRSSI
    @Published var currentSignalStrength: Int = 0
    @Published var signalStrengths: [Int] = [Int]()
    
    // SSID
    @Published var SSID: String = "unknown"
    
    // link auth
    @Published var auth: String = "unknown"
    
    // state
    @Published var wifiState: String = "unknown"
    
    // op mode
    @Published var mode: String = "station"
    
    // maxRate
    @Published var maxRate: Int = 0
    
    
    //    MARK: - Internet IP
    
    @Published var ipv4: String = "0.0.0.0"
    @Published var ipv6: String = "0.0.0.0"
    
    //    MARK: Speed test
    @Published var isSpeedTestRunning: Bool = true
    @Published var currentUpload: String = "0 Mbps"
    @Published var currentDownload: String = "0 Mbps"
    @Published var uploadFlows: Int = 0
    @Published var downloadFlows: Int = 0
    @Published var responsiveness: String = "0 RPM"
    
    init(){
        getLocalIpDetails()
    }
    
    
    func getLocalIpDetails(){
        let shellOut = shell("/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I")
        let lines = shellOut.split(whereSeparator: \.isNewline)
        for line in lines{
            let key = lineToKeyVal(line).first!
            let value = lineToKeyVal(line).last!
            switch key{
            case "agrCtlRSSI":
                currentSignalStrength = Int(value ) ?? 0
                signalStrengths.append(currentSignalStrength)
            case "SSID":
                SSID = value
            case "link auth":
                auth = value
            case "state":
                wifiState = value
            case "op mode":
                wifiState = value
            case "maxRate":
                maxRate = Int(value) ?? 0
            default:
                print("")
                //                    print("Key not used: \(key)")
            }
            
        }
        
        localIP = getIpUsingShell()
        print(localIP, SSID)
    }
    
    func testDownloadSpeed () {
        DispatchQueue.main.async {
            self.isSpeedTestRunning = true
        }
        let shellOut = shell("networkQuality")
        
        let lines = shellOut.split(whereSeparator: \.isNewline)
        for line in lines {
            let key = lineToKeyVal(line).first!
            let value = lineToKeyVal(line).last!
            print("KEY: \(key), VALUE: \(value)")
            switch key{
            case "Upload capacity":
                DispatchQueue.main.async {
                    self.currentUpload = value
                }
            case "Download capacity":
                DispatchQueue.main.async {
                    self.currentDownload = value
                }
            case "Upload flows":
                DispatchQueue.main.async {
                    self.uploadFlows = Int(value) ?? 0
                }
            case "Download flows":
                DispatchQueue.main.async {
                    self.downloadFlows = Int(value) ?? 0
                }
            case "Responsiveness":
                DispatchQueue.main.async {
                    self.responsiveness = self.extractResponsiveness(value)
                }
            default:
                print("")
                //                    print("Key not used: \(key)")
                
            }
        }
        DispatchQueue.main.async {
            self.isSpeedTestRunning = false
        }
        print(self.downloadFlows)
    }
    
    
    
    // MARK: - Helper Functions
    
    func extractResponsiveness(_ value: String) -> String {
//        TODO: Remove words inside the bracket
        return value
    }
    
    func lineToKeyVal(_ line: String.SubSequence) -> [String] {
        
        let cleanLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let key = cleanLine.split(separator: ":").first?.trimmingCharacters(in: .whitespaces) ?? "Unknown"
        let value = cleanLine.split(separator: ":").last?.trimmingCharacters(in: .whitespaces) ?? "Unknown"
        print(key, value)
        return [key, value]
    }
    
    func getIpUsingShell() -> String{
        let ip = shell("ifconfig | grep \"inet \" | grep -Fv 127.0.0.1 | awk '{print $2}'")
        return ip.replacingOccurrences(of: "\n", with: "")
    }
    
    func shell(_ command: String) -> String {
        let task = Process()
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
}
