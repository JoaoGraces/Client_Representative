//
//  RepresentativeClientsViewModel.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Ribeiro Noronha on 26/11/25.
//

import SwiftUI
import FirebaseAuth

class RepresentativeClientsViewModel: ObservableObject {
    @Published var clients: [User] = []
    @Published var isLoading = false
    
    @MainActor
    func fetchClients() async {
        self.isLoading = true
        
        // Pega o email do representante logado atual
        guard let currentEmail = Auth.auth().currentUser?.email else {
            print("Erro: Nenhum usuário logado")
            self.isLoading = false
            return
        }
        
        do {
            let fetchedClients = try await FirestoreManager.shared.getClientsForRepresentative(repEmail: currentEmail)
            self.clients = fetchedClients
        } catch {
            print("Erro ao buscar clientes: \(error.localizedDescription)")
        }
        
        self.isLoading = false
    }
    func logout() {
          do {
              try Auth.auth().signOut()
          } catch {
              print("Erro ao sair: \(error.localizedDescription)")
          }
      }
}

struct RepresentativeClientsView: View {
    @StateObject private var viewModel = RepresentativeClientsViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Carregando carteira de clientes...")
                } else if viewModel.clients.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "person.2.slash")
                            .font(.largeTitle)
                            .foregroundStyle(DS.Colors.neutral900.opacity(0.5))
                        Text("Nenhum cliente vinculado.")
                            .font(DS.Typography.body())
                            .foregroundStyle(DS.Colors.neutral900.opacity(0.7))
                    }
                } else {
                    List(viewModel.clients) { client in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(client.name)
                                    .font(DS.Typography.caption())
                                    .foregroundStyle(DS.Colors.neutral900)
                                
                                Text(client.email)
                                    .font(.caption)
                                    .foregroundStyle(DS.Colors.neutral900.opacity(0.6))
                            }
                            Spacer()
                            
                            // Badge de Status (Opcional)
                            Text(client.role == "pending" ? "Pendente" : "Ativo")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(client.role == "pending" ? Color.orange.opacity(0.2) : Color.green.opacity(0.2))
                                .foregroundStyle(client.role == "pending" ? Color.orange : Color.green)
                                .cornerRadius(4)
                        }
                        .padding(.vertical, 4)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Meus Clientes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.logout()
                    }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundStyle(Color.red)
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchClients()
                }
            }
        }
    }
}
