//
//  RegisterView.swift
//  OrderFlowWhiteLabel
//
//  Created by Mirelle Alves Sine on 16/10/25.
//

import Foundation
import SwiftUI

struct RegisterView<ViewModel: RegisterViewModeling>: View {
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 0) {
            TitleTextCentered(text: "Crie Sua Conta")
                .padding(.top, 24)

            Text("Preencha seus dados para começar a gerenciar seus pedidos.")
                .multilineTextAlignment(.center)
                .foregroundStyle(DS.Colors.neutral900.opacity(0.7))
                .padding(.horizontal, 32)
                .padding(.top, 8)

            VStack(spacing: 16) {
                IconTextField(text: $viewModel.fullName, placeholder: "Nome Completo", systemImage: "person.crop.circle")
                    .textContentType(.name)
                    .submitLabel(.next)

                IconTextField(text: $viewModel.email, placeholder: "E-mail", systemImage: "envelope", keyboard: .emailAddress, autocapitalization: .never)
                    .textContentType(.emailAddress)
                    .submitLabel(.next)

                IconTextField(text: $viewModel.phone, placeholder: "Telefone", systemImage: "phone", keyboard: .numberPad)
                    .textContentType(.telephoneNumber)
                    .submitLabel(.next)

                IconSecureField(text: $viewModel.password, placeholder: "Senha", systemImage: "lock")
                    .textContentType(.newPassword)
                    .submitLabel(.next)

                IconSecureField(text: $viewModel.confirmPassword, placeholder: "Confirmar Senha", systemImage: "lock")
                    .textContentType(.newPassword)
                    .submitLabel(.done)
            }
            .padding(.horizontal, DS.Spacing.pageLeading)
            .padding(.top, 24)
            
            HStack(spacing: 8) {
                Image(systemName: "briefcase")
                    .foregroundStyle(DS.Colors.neutral900.opacity(0.6))
                    .frame(width: 20, height: 20)
                
                Menu {
                    ForEach(viewModel.representatives, id: \.self) { rep in
                        Button(rep) {
                            viewModel.selectedRepresentative = rep
                        }
                    }
                } label: {
                    HStack {
                        Text(viewModel.selectedRepresentative == nil ? "Selecione o Representante" : "Representante: \(viewModel.selectedRepresentative!)")
                            .foregroundStyle(viewModel.selectedRepresentative == nil ? DS.Colors.neutral900.opacity(0.3) : DS.Colors.neutral900)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Image(systemName: "chevron.down")
                            .foregroundStyle(DS.Colors.neutral900.opacity(0.6))
                            .font(.caption)
                    }
                }
            }
            .padding(.horizontal, DS.Spacing.insetX)
            .frame(minHeight: 52)
            .background(
                RoundedRectangle(cornerRadius: DS.Radius.sm, style: .continuous)
                    .fill(DS.Colors.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: DS.Radius.sm, style: .continuous)
                    .stroke(DS.Colors.neutral900.opacity(0.15), lineWidth: 1)
            )
            .background(DS.Shadow.xs())
            .padding()

            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                PrimaryButton(title: "Criar Conta") {
                    Task {
                        await viewModel.createAccount()
                    }
                }
                    .disabled(!viewModel.isFormValid)
                    .padding(.top, 24)
            }

            Button(action: viewModel.goToLogin) {
                Text("Já tem uma conta? Voltar ao Login")
                    .font(.callout)
                    .fontWeight(.semibold)
            }
            .tint(DS.Colors.blueBase)
            .padding(.vertical, 16)
        }
        .background(DS.Colors.white)
        .ignoresSafeArea(edges: [])
    }
}

struct TitleTextCentered: View {
    let text: String
    var body: some View {
        Text(text)
            .font(DS.Typography.title())
            .foregroundStyle(DS.Colors.neutral900)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, DS.Spacing.pageLeading)
            .accessibilityAddTraits(.isHeader)
    }
}

struct IconTextField: View {
    @Binding var text: String
    let placeholder: String
    let systemImage: String
    var keyboard: UIKeyboardType = .default
    var autocapitalization: TextInputAutocapitalization = .words

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .foregroundStyle(DS.Colors.neutral900.opacity(0.6))
                .frame(width: 20, height: 20)

            TextField(placeholder, text: $text)
                .keyboardType(keyboard)
                .textInputAutocapitalization(autocapitalization)
                .disableAutocorrection(true)
                .foregroundStyle(DS.Colors.neutral900)
                .accessibilityLabel(placeholder)
        }
        .padding(.horizontal, DS.Spacing.insetX)
        .frame(minHeight: 52)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: DS.Radius.sm, style: .continuous)
                .fill(DS.Colors.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DS.Radius.sm, style: .continuous)
                .stroke(DS.Colors.neutral900.opacity(0.15), lineWidth: 1)
        )
        .background(DS.Shadow.xs())
    }
}

struct IconSecureField: View {
    @Binding var text: String
    let placeholder: String
    let systemImage: String
    @State private var isSecure: Bool = true

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .foregroundStyle(DS.Colors.neutral900.opacity(0.6))
                .frame(width: 20, height: 20)

            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .textInputAutocapitalization(.none)
            .disableAutocorrection(true)
            .foregroundStyle(DS.Colors.neutral900)
            .accessibilityLabel(placeholder)

            Button {
                isSecure.toggle()
            } label: {
                Image(systemName: isSecure ? "eye.slash" : "eye")
                    .foregroundStyle(DS.Colors.neutral900.opacity(0.6))
            }
            .accessibilityLabel(isSecure ? "Mostrar senha" : "Ocultar senha")
        }
        .padding(.horizontal, DS.Spacing.insetX)
        .frame(minHeight: 52)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: DS.Radius.sm, style: .continuous)
                .fill(DS.Colors.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DS.Radius.sm, style: .continuous)
                .stroke(DS.Colors.neutral900.opacity(0.15), lineWidth: 1)
        )
        .background(DS.Shadow.xs())
    }
}

// MARK: - Previews

//#Preview("RegisterView") {
//    RegisterView(viewModel: RegisterViewModel())
//        .previewDisplayName("Cadastro")
//        .padding(.vertical, 8)
//}
