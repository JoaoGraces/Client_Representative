//
//  RegisterViewModel.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Eduardo on 03/11/25.
//

import Foundation
import SwiftUI

protocol RegisterViewModeling: ObservableObject {
    var fullName: String { get set }
    var email: String { get set }
    var phone: String { get set }
    var password: String { get set }
    var confirmPassword: String { get set }
    
    var isFormValid: Bool { get }
    var isLoading: Bool { get }
    
    func createAccount() async
    func goToLogin()
}

class RegisterViewModel: RegisterViewModeling {
    @Published var fullName: String = "" {
        didSet { validateForm() }
    }
    @Published var email: String = "" {
        didSet { validateForm() }
    }
    @Published var phone: String = ""
    @Published var password: String = "" {
        didSet { validateForm() }
    }
    @Published var confirmPassword: String = "" {
        didSet { validateForm() }
    }
    
    @Published private(set) var isFormValid: Bool = false
    @Published private(set) var isLoading: Bool = false
    
    private let coordinator: AuthCoordinator
        
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }

    func createAccount() async {
        await MainActor.run {
            isLoading = true
        }
        
        do {
            try await AuthService.shared.register(email: email, password: password)
            
            await coordinator.completeAuthentication(role: .pending)
        } catch {
            print(error.localizedDescription)
        }
        
        await MainActor.run {
            isLoading = false
        }
    }
    
    func goToLogin() {
        Task { @MainActor in
            coordinator.switchTo(route: .login)
        }
    }
    
    private func validateForm() {
        let isNameValid = !fullName.trimmingCharacters(in: .whitespaces).isEmpty
        let isEmailValid = email.contains("@")
        let isPasswordValid = password.count >= 6 && password == confirmPassword
        
        self.isFormValid = isNameValid && isEmailValid && isPasswordValid
    }
}
