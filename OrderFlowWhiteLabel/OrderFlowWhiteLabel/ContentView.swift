//
//  ContentView.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Eduardo on 02/10/25.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        ClientCoordinatorView().onAppear {
            Task {
                await OrderFlowCache.shared.set("johnDoes@example.com", forKey: .email)
            }
        }
            
    }
}


#Preview {
    ContentView()
}
