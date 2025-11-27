//
//  ContentView.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Eduardo on 02/10/25.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
      /*  ClientCoordinatorView().onAppear {
            Task {
                await OrderFlowCache.shared.set("dasadsasdads@sddas.com", forKey: .email)
            }
        } */
        RootCoordinatorView()
    }
}


#Preview {
    ContentView()
}
