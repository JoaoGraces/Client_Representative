//
//  Empresa.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Ribeiro Noronha on 02/10/25.
//

import Foundation

struct Empresa: Codable, Identifiable {
    let id: UUID
    let razaoSocial: String
    let nomeFantasia: String
    let cnpj: String
    let tipo: EmpresaTipo
    let distribuidoraPaiId: UUID?
}

enum EmpresaTipo: String, Codable {
    case distribuidora = "DISTRIBUIDORA"
    case clienteFinal = "CLIENTE_FINAL"
}
