//
//  FormTextField.swift
//  Trabalho
//
//  Created by Scarllet Gomes on 15/10/25.
//

import SwiftUI

struct FormTextField: View {
    var icon: String
    var placeholder: String
    var keyboardType: UIKeyboardType = .default
    
    var isSecureField: Bool = false
    
    @State private var showPassword: Bool = false
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: horizontalPadding) {
            Image(systemName: icon)
                .foregroundColor(.gray)
            
            if !isSecureField || showPassword {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .font(.system(.body, design: .default, weight: .regular))
            } else {
                SecureField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .font(.system(.body, design: .default, weight: .regular))
            }
            
            if isSecureField {
                Button(action: {
                    showPassword.toggle()
                }, label: {
                    Image(systemName: showPassword ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                })
            }
        }
        .padding()
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadiusPattern)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    CustomerRegistrationView()
}
