//
//  UsersView.swift
//  OrderFlowWhiteLabel
//
//  Created by João Victor Bernardes Gracês on 02/11/25.
//

import SwiftUI

struct UsersView: View {
    @StateObject private var viewModel = UsersViewModel()

    var body: some View {
        VStack(spacing: 20) {
            if viewModel.isLoading {
                ProgressView("Carregando usuário...")
            } else if let user = viewModel.user {
                VStack {
                    Text("Nome: \(user.name)")
                        .font(.headline)
                    Text("Idade: \(user.age)")
                        .font(.subheadline)
                }
                .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text("Erro: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                Text("Nenhum dado carregado ainda")
            }

            Button("Buscar Usuário") {
                Task {
                    await viewModel.fetchUser()
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .padding()
    }
}
