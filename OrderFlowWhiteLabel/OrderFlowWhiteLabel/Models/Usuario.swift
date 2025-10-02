//
//  Usuario.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Ribeiro Noronha on 02/10/25.
//
import Foundation

struct Usuario: Codable, Identifiable {
    let id: UUID
    let nomeCompleto: String
    let senha_hash: String
    let email: String
    let papel: UsuarioPapel
    let empresaId: UUID
    let dataCriacao: Date
}

enum UsuarioPapel: String, Codable {
    case adminCliente = "ADMIN_CLIENTE"
    case funcionarioCliente = "FUNCIONARIO_CLIENTE"
    case representante = "REPRESENTANTE"
    case adminDistribuidora = "ADMIN_DISTRIBUIDORA"
}
