//
//  LoginViewModel.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Eduardo on 04/11/25.
//

import Foundation
import SwiftUI

protocol LoginViewModeling: ObservableObject {
    var email: String { get set }
    var password: String { get set }
    
    func login() async
    func goToRegister()
}

class LoginViewModel: LoginViewModeling {
    @Published var email: String = ""
    @Published var password: String = ""
    
    private let coordinator: AuthCoordinator
    
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
    func login() async {
        await MainActor.run {
            //            isLoading = true
        }
        
        do {
            try await AuthService.shared.signIn(email: email, password: password)            // 2. Buscamos a role usando o
            let role = try await FirestoreManager.shared.getUserRole(email: self.email)
            
            await OrderFlowCache.shared.set(email, forKey: .email)
            
            await coordinator.completeAuthentication(role: role)
        } catch {
            print(error.localizedDescription)
        }
        
        await MainActor.run {
            //            isLoading = false
        }
    }
    
    func goToRegister() {
        Task { @MainActor in
            coordinator.switchTo(route: .register)
        }
    }
}
