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
    var address: String { get set }
    
    var password: String { get set }
    var confirmPassword: String { get set }
    var selectedRepresentativeEmail: String? { get set }
    var representatives: [Representative] { get }
    
    var isFormValid: Bool { get }
    var isLoading: Bool { get }
    
    func createAccount() async
    func goToLogin()
}

class RegisterViewModel: RegisterViewModeling {
    @Published var fullName: String = "" { didSet { validateForm() } }
    @Published var email: String = "" { didSet { validateForm() } }
    @Published var phone: String = ""
    @Published var address: String = ""
    
    @Published var password: String = "" { didSet { validateForm() } }
    @Published var confirmPassword: String = "" { didSet { validateForm() } }
    @Published var selectedRepresentativeEmail: String? = nil { didSet { validateForm() } }
    
    
    @Published var representatives: [Representative] = []
    
    @Published private(set) var isFormValid: Bool = false
    @Published private(set) var isLoading: Bool = false
    
    private let coordinator: AuthCoordinator
    
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
        Task { await loadRepresentatives() }
    }
    
    // 5. ADICIONADO: Função que busca no Firestore
    @MainActor
    func loadRepresentatives() async {
        do {
            self.representatives = try await FirestoreManager.shared.getAllRepresentatives()
        } catch {
            print("Erro ao carregar representantes: \(error.localizedDescription)")
        }
    }
    
    func createAccount() async {
        await MainActor.run { isLoading = true }
        
        do {
            guard let repEmail = selectedRepresentativeEmail else {
                print("Erro: Nenhum representante selecionado")
                isLoading = false
                return
            }
            
            try await AuthService.shared.register(
                email: email,
                password: password,
                name: fullName,
                phone: phone,
                address: address,
                representativeEmail: repEmail
            )
            
            await OrderFlowCache.shared.set(email, forKey: .email)
            await coordinator.completeAuthentication(role: .pending)
            
        } catch {
            print("Erro: \(error.localizedDescription)")
        }
        await MainActor.run { isLoading = false }
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
        let isAddressValid = !address.isEmpty
        let isRepresentativeValid = selectedRepresentativeEmail != nil
        self.isFormValid = isNameValid && isEmailValid && isPasswordValid && isAddressValid && isRepresentativeValid
    }
}
