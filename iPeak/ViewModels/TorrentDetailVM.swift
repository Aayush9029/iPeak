//
//  TorrentDetailVM.swift
//  iPeak
//
//  Created by Aayush Pokharel on 2021-12-22.
//

import SwiftUI

class Torre    ntDetailVM: ObservableObject {
    
    @Published var ip: String
    @Published var
    
    let url = URL(string:"https://en.wikipedia.org/wiki/Aglaonema")!
    let html = try String(contentsOf: url)
    print(html.prefix(200))
