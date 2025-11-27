//
//  LoginView.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Eduardo on 04/11/25.
//

import Foundation
import SwiftUI

struct LoginView<ViewModel: LoginViewModeling>: View {
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                TitleTextCentered(text: "Bem-vindo ao OrderFlow")
                
                Text("Faça login na sua conta")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(DS.Colors.neutral900.opacity(0.7))
                    .padding(.horizontal, 32)
                
                IconTextField(text: $viewModel.email, placeholder: "E-mail", systemImage: "envelope", keyboard: .emailAddress, autocapitalization: .never)
                    .textContentType(.emailAddress)
                    .submitLabel(.next)
                    
                
                IconSecureField(text: $viewModel.password, placeholder: "Senha", systemImage: "lock")
                    .textContentType(.newPassword)
                    .submitLabel(.next)
                
                PrimaryButton(title: viewModel.isLoading ? "Entrando..." : "Login") {
                    Task {
                        await viewModel.login()
                    }
                }
                .padding(.top, 24)
                .opacity(viewModel.isLoading ? 0.6 : 1.0)
                .disabled(viewModel.isLoading)
                
                Button(action: viewModel.goToRegister) {
                    Text("Já tem uma conta? Voltar ao Login")
                        .font(.callout)
                        .fontWeight(.semibold)
                }
                .tint(DS.Colors.blueBase)
                .padding(.vertical, 16)
            }
            .padding(.horizontal, DS.Spacing.pageLeading)
            .padding(.top, 24)
        }
        .background(DS.Colors.white)
        .ignoresSafeArea(edges: [])
        .alert("Atenção", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
    
}
