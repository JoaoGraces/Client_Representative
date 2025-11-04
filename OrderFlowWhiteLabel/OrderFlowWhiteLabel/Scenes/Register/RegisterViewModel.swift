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
    
    func createAccount()
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
    
    private let coordinator: AuthCoordinator
        
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }

    func createAccount() {
        Task { @MainActor in
            coordinator.completeAuthentication()
        }
    }
    
    func goToLogin() {
        
    }
    
    private func validateForm() {
        let isNameValid = !fullName.trimmingCharacters(in: .whitespaces).isEmpty
        let isEmailValid = email.contains("@")
        let isPasswordValid = password.count >= 6 && password == confirmPassword
        
        self.isFormValid = isNameValid && isEmailValid && isPasswordValid
    }
}
