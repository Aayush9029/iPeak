//
//  PulseView.swift
//  iPeak
//
//  Created by Aayush Pokharel on 2021-12-14.
//

import SwiftUI

struct PulseView: View {
    
    @State private var shouldAnimate = false
    
    var animation: Animation {
        Animation.easeIn(duration: 1)
        .repeatForever(autoreverses: false)
    }
    @State private var isRotated = false
    
    var body: some View {
        ZStack{
        Circle()
            .fill(Color("Color1"))
            .frame(width: 100, height: 100)
            .overlay(
                ZStack {
                    Circle()
                        .stroke(.teal, lineWidth: 100)
                        .scaleEffect(shouldAnimate ? 1 : 0.1)
                    Circle()
                        .stroke(.teal, lineWidth: 100)
                        .scaleEffect(shouldAnimate ? 1.5 : 0.1)
                    Circle()
                        .stroke(.teal, lineWidth: 100)
                        .scaleEffect(shouldAnimate ? 2 : 0.1)
                }
                .opacity(shouldAnimate ? 0.1 : 0.5)
                .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: false))
            )
            .onAppear {
                self.shouldAnimate = true
                self.isRotated = true
            }
        }
    }
    
}


struct PulseView_Previews: PreviewProvider {
    static var previews: some View {
        PulseView()
    }
}
