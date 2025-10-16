//
//  Constants.swift
//  Trabalho
//
//  Created by Scarllet Gomes on 15/10/25.
//
import Foundation

var horizontalPadding: CGFloat = 16

var smallVerticalPadding: CGFloat = 8
var mediumVerticalPadding: CGFloat = 12
var largeVerticalPadding: CGFloat = 24

var cornerRadiusPattern: CGFloat = 8

enum ValidationError: LocalizedError {
    case emptyFields
    case invalidPassword
    case invalidEmail
    case passwordMismatch
    case invalidPhoneNumber
    
    var errorDescription: String? {
        switch self {
        case .emptyFields:
            return "Por favor, preencha todos os campos"
        case .invalidPassword:
            return "Por favor, insira uma senha válida (mínimo 8 caracteres, incluindo ao menos uma letra maiúscula, uma letra minúscula, um número e um caractere especial)"
        case .invalidEmail:
            return "Por favor, insira um e-mail válido. ex: usuario@exemplo.com"
        case .passwordMismatch:
            return "As senhas não coincidem"
        case .invalidPhoneNumber:
            return "Por favor, insira um número de telefone válido. ex: (99) 99999-9999"
            
        }
    }
}
