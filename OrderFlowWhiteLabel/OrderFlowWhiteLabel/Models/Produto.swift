//
//  Produto.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Ribeiro Noronha on 02/10/25.
//

import Foundation

struct Produto: Codable, Identifiable {
    let id: UUID
    let distribuidoraId: UUID
    let nome: String
    let descricao: String
    let preco: Decimal
    let estoque: Int
}
