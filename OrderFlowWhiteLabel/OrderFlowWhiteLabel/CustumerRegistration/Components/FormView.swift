//
//  FormView.swift
//  Trabalho
//
//  Created by Scarllet Gomes on 15/10/25.
//

import SwiftUI

struct FormView: View {
    var nameIcon: String
    var emailIcon: String
    var phoneIcon: String
    var passwordIcon: String
    
    var nameTextField: String
    var emailTextField: String
    var phoneTextField: String
    var passwordTextField: String
    var confirmPasswordTextField: String
    
    @Binding var fullName: String
    @Binding var email: String
    @Binding var phone: String
    @Binding var password: String
    @Binding var confirmPassword: String
    
    var body: some View {
        VStack(spacing: largeVerticalPadding) {
            FormTextField(icon: nameIcon, placeholder: nameTextField, text: $fullName)
            
            FormTextField(icon: emailIcon, placeholder: emailTextField, keyboardType: .emailAddress, text: $email)
            
            FormTextField(icon: phoneIcon, placeholder: phoneTextField,keyboardType: .phonePad, text: $phone)
            
            FormTextField(icon: passwordIcon, placeholder: passwordTextField, isSecureField: true, text: $password)
            
            FormTextField(icon: passwordIcon, placeholder: confirmPasswordTextField, isSecureField: true, text: $confirmPassword)
            
        }
        .padding(.horizontal, horizontalPadding)
    }
}

#Preview {
    CustomerRegistrationView()
}
