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
    
    @MainActor
    func changeClientStatus(client: User, newStatus: UserRole) async {
        guard let clientId = client.id else {
            print("Erro: Usuário sem ID de documento.")
            return
        }
        
        self.isLoading = true
        
        do {
            try await FirestoreManager.shared.updateClientRole(userId: clientId, newRole: newStatus)
            
            if let index = self.clients.firstIndex(where: { $0.id == clientId }) {
                self.clients[index].role = newStatus
                // if newStatus == "refused" { self.clients.remove(at: index) }
            }
            
        } catch {
            print("Erro ao atualizar status: \(error.localizedDescription)")
        }
        
        self.isLoading = false
    }
    
}
