//
//  ContentView.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Eduardo on 02/10/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}


struct LoginView:View {
    var body: some View {
        Text("Login View")
    }
}


struct AccountCreated:View {
    @State var usuario: Usuario
    
    var body: some View {
        VStack{
            Text("\(usuario.dataCriacao)")
                .padding()
            Text("\(usuario.id)")
                .padding()
            Text("\(usuario.empresaId)")
                .padding()
            Text(usuario.nomeCompleto)
                .padding()
            Text(usuario.email)
                .padding()
            Text(usuario.senha_hash)
                .padding()
            Text("\(usuario.papel.rawValue)")
                .padding()
            
        }
    }
}
