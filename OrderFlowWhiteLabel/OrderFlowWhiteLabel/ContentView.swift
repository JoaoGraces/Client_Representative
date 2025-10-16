//
//  ContentView.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Eduardo on 02/10/25.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        RegisterView(
            onCreateAccount: { fullName, email, phone, password in
                // Integre aqui com seu ViewModel/Service
                print("Criar conta:", fullName, email, phone, password)
            },
            onGoToLogin: {
                print("Voltar ao Login")
            }
        )
    }
}


#Preview {
    ContentView()
}
