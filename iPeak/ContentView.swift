//
//  ContentView.swift
//  iPeak
//
//  Created by Aayush Pokharel on 2021-12-14.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var ipvm: iPeakViewModel

    var body: some View {
        NavigationView {
            SidebarListView()
                .environmentObject(ipvm)
            LocalIPDetailsView()
                .environmentObject(ipvm)
                .frame(minWidth: 300, idealWidth: 600)
        }
        .symbolVariant(.fill)
    }
}
