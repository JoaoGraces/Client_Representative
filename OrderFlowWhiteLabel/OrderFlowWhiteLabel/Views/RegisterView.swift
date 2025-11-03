//
//  RegisterView.swift
//  OrderFlowWhiteLabel
//
//  Created by Mirelle Alves Sine on 16/10/25.
//

import Foundation

import SwiftUI

// MARK: - Register View

struct RegisterView: View {
    // Estados dos campos
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""

    var onCreateAccount: (_ fullName: String, _ email: String, _ phone: String, _ password: String) -> Void = { _,_,_,_ in }
    var onGoToLogin: () -> Void = {}

    // Validação simples só para habilitar/desabilitar o CTA
    private var isFormValid: Bool {
        !fullName.trimmingCharacters(in: .whitespaces).isEmpty &&
        email.contains("@") &&
        password.count >= 6 &&
        password == confirmPassword
    }

    var body: some View {
        VStack(spacing: 0) {
            // Título centralizado (usa tokens do DS)
            TitleTextCentered(text: "Crie Sua Conta")
                .padding(.top, 24)

            Text("Preencha seus dados para começar a gerenciar seus pedidos.")
                .multilineTextAlignment(.center)
                .foregroundStyle(DS.Colors.neutral900.opacity(0.7))
                .padding(.horizontal, 32)
                .padding(.top, 8)

            // Campos
            VStack(spacing: 16) {
                IconTextField(text: $fullName,
                              placeholder: "Nome Completo",
                              systemImage: "person.crop.circle")
                    .textContentType(.name)
                    .submitLabel(.next)

                IconTextField(text: $email,
                              placeholder: "E-mail",
                              systemImage: "envelope",
                              keyboard: .emailAddress,
                              autocapitalization: .never)
                    .textContentType(.emailAddress)
                    .submitLabel(.next)

                IconTextField(text: $phone,
                              placeholder: "Telefone",
                              systemImage: "phone",
                              keyboard: .numberPad)
                    .textContentType(.telephoneNumber)
                    .submitLabel(.next)

                IconSecureField(text: $password,
                                placeholder: "Senha",
                                systemImage: "lock")
                    .textContentType(.newPassword)
                    .submitLabel(.next)

                IconSecureField(text: $confirmPassword,
                                placeholder: "Confirmar Senha",
                                systemImage: "lock")
                    .textContentType(.newPassword)
                    .submitLabel(.done)
            }
            .padding(.horizontal, DS.Spacing.pageLeading)
            .padding(.top, 24)

//            Spacer(minLength: 0)

            // CTA
            PrimaryButton(title: "Criar Conta") {
                onCreateAccount(fullName, email, phone, password)
            }
            .disabled(!isFormValid)
            .padding(.top, 24)

            // Link para login
            Button(action: onGoToLogin) {
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

// MARK: - Componentes Reutilizáveis

/// Mesma tipografia do DS, mas centralizada (não altera o TitleText existente)
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

/// Campo com ícone à esquerda (texto comum)
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

/// Campo com ícone à esquerda (seguro)
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

#Preview("RegisterView") {
    RegisterView()
        .previewDisplayName("Cadastro")
        .padding(.vertical, 8)
}
