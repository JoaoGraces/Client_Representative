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
    let quantidade: Int
    let precoUnidade: Double
    var preco: Double { Double(quantidade) * precoUnidade }
    let estoque: Int
    var descricao: String {
        "\(quantidade) x R$ \(precoUnidade.formattedMoney)/un."
    }
}
