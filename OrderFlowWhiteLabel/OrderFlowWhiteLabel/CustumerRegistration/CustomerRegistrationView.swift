//
//  CustomerRegistrationView.swift
//  Trabalho
//
//  Created by Scarllet Gomes on 14/10/25.
//

import SwiftUI

struct CustomerRegistrationView: View {
    @State private var viewModel: ViewModel = ViewModel()
    
    private var titleString = "Crie Sua Conta"
    private var disclaimerString = "Preencha seus dados para começar a gerenciar seus pedidos."
    
    private var nameIcon = "person"
    private var emailIcon = "envelope"
    private var phoneIcon = "phone"
    private var passwordIcon = "lock"
    
    private var nameTextField = "Nome Completo"
    private var emailTextField = "E-mail"
    private var phoneTextField = "Telefone"
    private var passwordTextField = "Senha"
    private var confirmPasswordTextField = "Confirmar Senha"
    private var buttonText = "Criar Conta"
    private var alreadyHaveAccountText = "Já tem uma conta? Voltar para Login"
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack(spacing: largeVerticalPadding) {
                        
                        Spacer()
                        
                        //header
                        CustomerRegistrationHeader(titleString: titleString, disclaimerString: disclaimerString)
                        
                        //form
                        FormView(nameIcon: nameIcon,
                                 emailIcon: emailIcon,
                                 phoneIcon: phoneIcon,
                                 passwordIcon: passwordIcon,
                                 nameTextField: nameTextField,
                                 emailTextField: emailTextField,
                                 phoneTextField: phoneTextField,
                                 passwordTextField: passwordTextField,
                                 confirmPasswordTextField: confirmPasswordTextField,
                                 fullName: $viewModel.fullName,
                                 email: $viewModel.email,
                                 phone: $viewModel.phone,
                                 password: $viewModel.password,
                                 confirmPassword: $viewModel.confirmPassword
                        )
                        
                        Button(action: {
                            viewModel.register()
                        }) {
                            ButtonTextView(text: buttonText)
                        }
                        .padding(horizontalPadding)
                        
                        Text(viewModel.error)
                            .padding(.horizontal, horizontalPadding)
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.goToLogin.toggle()
                        }) {
                            FooterLinkTextView(text: alreadyHaveAccountText)
                        }
                    }
                }
                .background(Color(UIColor.systemGray6))
            }
            .background(Color(UIColor.systemGray6))
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $viewModel.goToAccountCreated){
                AccountCreated(usuario: viewModel.usuario)
            }
            .navigationDestination(isPresented: $viewModel.goToLogin) {
                LoginView()
            }
            .onChange(of: viewModel.phone) { oldValue, newValue in
                viewModel.phone = newValue.formatToBrazilianPhone()
            }
        }
    }
}

extension CustomerRegistrationView {
    
    @Observable
    class ViewModel {
        var fullName = ""
        var email = ""
        var phone = ""
        var password = ""
        var confirmPassword = ""
        var usuario: Usuario = Usuario(id: UUID(), nomeCompleto: "", senha_hash: "", email: "", papel: .funcionarioCliente, empresaId: UUID(), dataCriacao: Date())
        var error: String = ""
        var goToLogin: Bool = false
        var goToAccountCreated: Bool = false
        
        init(){}
        
        func navigateToLogin(){
            goToLogin.toggle()
        }
        
        func register() {
            do {
                try validateRegistration()
                error = ""
                
                self.usuario = Usuario(id: UUID(), nomeCompleto: fullName, senha_hash: password, email: email, papel: .funcionarioCliente, empresaId: UUID(), dataCriacao: Date())
                
                self.goToAccountCreated.toggle()
            } catch {
                self.error = error.localizedDescription
            }
        }
        
        private func validateRegistration() throws {
            guard !fullName.isEmpty, !email.isEmpty, !phone.isEmpty,
                  !password.isEmpty, !confirmPassword.isEmpty else {
                throw ValidationError.emptyFields
            }
            
            guard email.isValidEmail() else {
                throw ValidationError.invalidEmail
            }
            
            guard phone.isValidPhone() else {
                throw ValidationError.invalidPhoneNumber
            }
            
            guard password.isValidPassword() else {
                throw ValidationError.invalidPassword
            }
            
            guard password == confirmPassword else {
                throw ValidationError.passwordMismatch
            }
            
        }
    }
}

#Preview {
    CustomerRegistrationView()
}
