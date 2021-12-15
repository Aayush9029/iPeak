//
//  SingleDetailView.swift
//  iPeak
//
//  Created by Aayush Pokharel on 2021-12-14.
//

import SwiftUI

struct SingleDetailView: View {
    let color: Color
    let icon: String
    let key: String
    let value: String
    var body: some View {
        HStack(spacing: 5){
            Image(systemName: icon)
                .font(.body.bold())
                .foregroundStyle(color)
            Text(key)
                .bold()
                .foregroundStyle(.tertiary)
            Text(value)
                .bold()
                .foregroundStyle(.secondary)
            Spacer()
        }.padding(6)
            .background(.ultraThinMaterial)
            .cornerRadius(10)
        
    }
}
