//
//  SidebarListView.swift
//  iPeak
//
//  Created by Aayush Pokharel on 2021-12-14.
//

import SwiftUI

struct SidebarListView: View {
    @State var selection: Set<Int> = []
    
    @EnvironmentObject var ipvm: iPeakViewModel
    
    var body: some View {
        List(selection: self.$selection) {
            NavigationLink {
                LocalIPDetailsView()
                    .environmentObject(ipvm)
                    .frame(minWidth: 300, idealWidth: 600)
            } label: {
                Label("Local ip", systemImage: "externaldrive.connected.to.line.below").accentColor(.orange)
            }
            .tag(0)
            NavigationLink {
                LocalIPDetailsView()
                    .environmentObject(ipvm)
                    .frame(minWidth: 300, idealWidth: 600)
            } label: {
                Label("Public ip", systemImage: "globe").accentColor(.purple)
            }
            .tag(1)
            NavigationLink {
                SpeedTestView()
                    .environmentObject(ipvm)
                    .frame(minWidth: 300, idealWidth: 600)
            } label: {
                Label("Speed test", systemImage: "arrow.up.arrow.down").accentColor(.teal)
            }
            .tag(2)
            
            Label("IP Lookup", systemImage: "eye.fill").accentColor(.red)
                .tag(4)
            Label("Scan Network", systemImage: "iphone.radiowaves.left.and.right").accentColor(.green)
                .tag(5)
            Label("Quick Ping", systemImage: "waveform.path.ecg").accentColor(.pink)
                .tag(6)
            Label("Gather Info", systemImage: "arrow.down.doc").accentColor(.blue)
                .tag(7)
        }
        .listStyle(SidebarListStyle())
        .frame(minWidth: 180, idealWidth: 180, maxWidth: 180, maxHeight: .infinity)
    }
}

struct SidebarListView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarListView()
            .environmentObject(iPeakViewModel())
    }
}
