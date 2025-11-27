//
//  RootCoordinator.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Eduardo on 03/11/25.
//

import SwiftUI

@MainActor
final class RootCoordinator: ObservableObject {
    enum RootFlow {
        case auth
        case clientApp
        case representativeApp
        case pending
        case refusedClient
    }
    
    @Published var currentFlow: RootFlow = .auth
    
    func completeAuthentication(role: UserRole) {
        withAnimation {
            switch role {
            case .pending:
                currentFlow = .pending
            case .client:
                currentFlow = .clientApp
            case .representative:
                currentFlow = .representativeApp
            case .refused:
                currentFlow = .refusedClient
            }
        }
    }
    func logout() {
        withAnimation {
            self.currentFlow = .auth
        }
    }
}

struct RootCoordinatorView: View {
    @StateObject private var coordinator = RootCoordinator()
    
    var body: some View {
        switch coordinator.currentFlow {
        case .auth:
            AuthCoordinatorView(rootCoordinator: coordinator)
            
        case .clientApp:
            ClientCoordinatorView()
            
        case .representativeApp:
            RepresentativeCoordinatorView(onLogout: {
                coordinator.logout()
            })
        case .pending:
            PendingView()
            
        case .refusedClient:
            RefusedClientView()
        }
    }
}
