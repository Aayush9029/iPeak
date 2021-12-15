//
//  LocalIPDetailsView.swift
//  iPeak
//
//  Created by Aayush Pokharel on 2021-12-14.
//

import SwiftUI

struct LocalIPDetailsView: View {
    @EnvironmentObject var ipvm: iPeakViewModel
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Group{
                    if ipvm.SSID != "unknown" {
                        Image(systemName: "circle.fill")
                            .foregroundColor(.green)
                            .clipShape(Circle())
                    }
                }
                Text(ipvm.localIP)
                    .font(.largeTitle.bold())
                Spacer()
            }
            
            Group{
                SingleDetailView(color: .blue, icon: "textformat.size", key: "SSID", value: "\(ipvm.SSID)")
                
                SingleDetailView(color: .green, icon: "bolt", key: "Signal Strength", value: "\(ipvm.currentSignalStrength)")
                
                SingleDetailView(color: .yellow, icon: "antenna.radiowaves.left.and.right", key: "Mode", value: ipvm.mode)
                SingleDetailView(color: .orange, icon: "lock", key: "Auth", value: ipvm.auth)
                
                SingleDetailView(color: .purple, icon: "dot.radiowaves.up.forward", key: "State", value: ipvm.wifiState)
                SingleDetailView(color: .teal, icon: "number", key: "maxRate", value: "\(ipvm.maxRate)")
                
            }
            Spacer()
        }
        .padding()
    }
}

struct LocalIPDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        LocalIPDetailsView()
            .environmentObject(iPeakViewModel())
            .frame(width: 250, height: 300)
    }
}
