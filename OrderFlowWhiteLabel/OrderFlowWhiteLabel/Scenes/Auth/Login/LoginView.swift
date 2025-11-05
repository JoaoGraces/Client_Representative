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
                IconTextField(text: $viewModel.email, placeholder: "E-mail", systemImage: "envelope", keyboard: .emailAddress, autocapitalization: .never)
                    .textContentType(.emailAddress)
                    .submitLabel(.next)

                IconSecureField(text: $viewModel.password, placeholder: "Senha", systemImage: "lock")
                    .textContentType(.newPassword)
                    .submitLabel(.next)
                
                PrimaryButton(title: "Login") {
                    Task {
                        await viewModel.login()
                    }
                }
                .padding(.top, 24)
            }
            .padding(.horizontal, DS.Spacing.pageLeading)
            .padding(.top, 24)
        }
        .background(DS.Colors.white)
        .ignoresSafeArea(edges: [])
    }
}
