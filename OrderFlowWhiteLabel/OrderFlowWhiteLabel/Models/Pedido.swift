//
//  Pedido.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Ribeiro Noronha on 02/10/25.
//
import Foundation
import SwiftUI

struct Pedido: Codable, Identifiable, Hashable {
    let id: UUID
    let empresaClienteId: UUID
    let usuarioCriadorId: UUID
    let representanteId: UUID
    let status: PedidoStatus
    let dataEntregaSolicitada: Date
    let dataVencimentoPagamento: Date
    let statusRecebimento: StatusRecebimento?
    let observacoesCliente: String?
    let dataCriacao: Date
    let produtos: [Produto]
    let taxaEntrega: Double
    
    var subtotal: Double { produtos.reduce(0) { $0 + $1.preco } }
    var total: Double { subtotal + taxaEntrega }
}

enum PedidoStatus: String, Codable {
    case criado = "CRIADO"
    case validado = "VALIDADO"
    case enviado = "ENVIADO"
    case entregue = "ENTREGUE"
    case finalizado = "FINALIZADO"
    case cancelamento = "CANCELAMENTO"
    case alteracao = "ALTERAÇÃO"
    
    func message() -> String {
        switch self {
        case .criado:
            return "Você tem um novo pedido para revisão."
        case .validado:
            return "Pedido Validado."
        case .enviado:
            return "Pedido Enviado."
        case .entregue:
            return "Pedido Entregue."
        case .finalizado:
            return "Pedido Finalizado."
        case .cancelamento:
            return "Pedido Cancelado."
        case .alteracao:
            return "Pedido Alterado."
        }
    }
    
    func getColor() -> Color {
        switch self {
        case .validado, .enviado, .entregue, .finalizado:
            return DS.Colors.blueBase
        case .criado:
            return DS.Colors.white
        case .cancelamento, .alteracao:
            return DS.Colors.golden
        }
    }
}

enum StatusRecebimento: String, Codable {
    case conforme = "CONFORME"
    case problemaRecebido = "PROBLEMA_RECEBIDO"
    case problemaNaoRecebido = "PROBLEMA_NAO_RECEBIDO"
}


struct PedidoComCliente {
    let pedido: Pedido
    let usuario: User
}
