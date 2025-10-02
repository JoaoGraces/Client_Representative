//
//  Pedido.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Ribeiro Noronha on 02/10/25.
//
import Foundation

struct Pedido: Codable, Identifiable {
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
}

enum PedidoStatus: String, Codable {
    case criado = "CRIADO"
    case validado = "VALIDADO"
    case enviado = "ENVIADO"
    case entregue = "ENTREGUE"
    case finalizado = "FINALIZADO"
}

enum StatusRecebimento: String, Codable {
    case conforme = "CONFORME"
    case problemaRecebido = "PROBLEMA_RECEBIDO"
    case problemaNaoRecebido = "PROBLEMA_NAO_RECEBIDO"
}
