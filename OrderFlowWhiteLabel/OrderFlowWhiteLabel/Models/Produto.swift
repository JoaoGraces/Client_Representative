//
//  Produto.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Ribeiro Noronha on 02/10/25.
//

import Foundation

struct Produto: Codable, Identifiable, Hashable {
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

struct OrderConfirmation: Hashable {
    let pedido: Pedido
    let itens: [Produto]
    let taxaEntrega: Double

    var subtotal: Double { itens.reduce(0) { $0 + $1.preco } }
    var total: Double { subtotal + taxaEntrega }

    var itensCountText: String {
        let c = itens.count
        return c == 1 ? "1 produto" : "\(c) produtos"
    }

    var statusText: String {
        switch pedido.status {
        case .criado: return "Criado"
        case .validado: return "Validado"
        case .enviado: return "Enviado"
        case .entregue: return "Entregue"
        case .finalizado: return "Finalizado"
        }
    }

    var dataString: String {
        let df = DateFormatter()
        df.locale = Locale(identifier: "pt_BR")
        df.dateStyle = .long
        return df.string(from: pedido.dataCriacao)
    }

    var orderIdText: String {
        // Ex.: #<prefix>-<AAAA><MM><DD>-<ultimos4>
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyyMMdd"
        let day = fmt.string(from: pedido.dataCriacao)
        let tail = String(pedido.id.uuidString.prefix(4)).uppercased()
        return "#OFP\(day)-\(tail)"
    }
}
