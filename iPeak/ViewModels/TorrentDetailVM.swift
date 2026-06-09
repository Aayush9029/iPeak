//
//  TorrentDetailVM.swift
//  iPeak
//
//  Created by Aayush Pokharel on 2021-12-22.
//

import SwiftUI

@MainActor
final class TorrentDetailVM: ObservableObject {
    @Published var ip: String
    @Published var title: String

    init(ip: String = "", title: String = "") {
        self.ip = ip
        self.title = title
    }
}
