//
//  SpeedTestView.swift
//  iPeak
//
//  Created by Aayush Pokharel on 2021-12-14.
//

import SwiftUI

struct SpeedTestView: View {
    @EnvironmentObject var ipvm: iPeakViewModel
    
    var body: some View {
        Group{
            if ipvm.isSpeedTestRunning {
                PulseView()
                    .onAppear {
                        DispatchQueue.global(qos: .userInitiated).async {
                            ipvm.testDownloadSpeed()
                        }
                    }
            }else{
                VStack(alignment: .center){
                    Spacer()
                    Group{
                        SpeedTestDetails(key: "Download Speed", value: ipvm.currentDownload)
                        
                        SpeedTestDetails(key: "Upload Speed", value: ipvm.currentUpload)
                    }
                    Group{
                        SpeedTestDetails(key: "Download flows", value:  "\(ipvm.downloadFlows)")
                        
                        SpeedTestDetails(key: "Upload flows", value: "\(ipvm.uploadFlows)")
                    }
                    Group{
                        SpeedTestDetails(key: "Responsiveness ", value: "\(ipvm.responsiveness)")
                    }
                    Spacer()
                    Button {
                        DispatchQueue.global(qos: .userInitiated).async {
                            ipvm.testDownloadSpeed()
                        }
                    } label: {
                        HStack{
                            Spacer()
                            Label("Restart", systemImage: "arrow.clockwise")
                                .foregroundStyle(.teal)
                                .font(.title2.bold())
                            Spacer()
                        }
                    }
                    .padding(8)
                    .background(.teal.opacity(0.5))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.teal, lineWidth: 2)
                    )
                    .padding()
                    .padding(.horizontal)
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct SpeedTestView_Previews: PreviewProvider {
    static var previews: some View {
        SpeedTestView()
            .frame(width: 300, height: 500)
            .environmentObject(iPeakViewModel())
    }
}

struct SpeedTestDetails: View {
    let key: String
    let value: String
    var body: some View {
        HStack(alignment: .center){
            Text(key)
                .font(.title3)
                .foregroundStyle(.tertiary)
            Spacer()
            Text(value)
                .font(.title3)
                .bold()
                .foregroundColor(.teal)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .padding(.horizontal)
        
    }
}
