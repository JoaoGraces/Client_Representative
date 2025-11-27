//
//  RepresentativeClientsView.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Ribeiro Noronha on 26/11/25.
//
import SwiftUI
import FirebaseAuth

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
                        ClientRowView(client: client) {
                            Task{
                                await viewModel.changeClientStatus(client: client, newStatus: UserRole.client)
                            }
                        } onRefuse: {
                            Task {
                                await viewModel.changeClientStatus(client: client, newStatus: UserRole.refused)
                                
                            }
                        }
                        
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

struct ClientRowView: View {
    let client: User
    var onAccept: () -> Void
    var onRefuse: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(client.name)
                        .font(DS.Typography.caption())
                        .foregroundStyle(DS.Colors.neutral900)
                    
                    Text(client.email)
                        .font(.caption)
                        .foregroundStyle(DS.Colors.neutral900.opacity(0.6))
                }
                
                Spacer()
                
                statusBadgeView
            }
            if client.role == .pending {
                Divider()
                HStack(spacing: 16) {
                    Button(action: onRefuse) {
                        Label("Recusar", systemImage: "xmark")
                            .font(.caption.bold())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    
                    Button(action: onAccept) {
                        Label("Aprovar", systemImage: "checkmark")
                            .font(.caption.bold())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private var statusBadgeView: some View {
        Text(statusText)
            .font(.caption2)
            .fontWeight(.bold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(badgeColor.opacity(0.2))
            .foregroundStyle(badgeColor)
            .cornerRadius(4)
    }
    
    private var statusText: String {
        switch client.role {
        case .pending: return "Pendente"
        case .refused: return "Recusado"
        case .client, .representative: return "Ativo"
        }
    }
    
    private var badgeColor: Color {
        switch client.role {
        case .pending:
            return .orange
        case .refused:
            return .red
        case .client, .representative:
            return .green
        }
    }
}
