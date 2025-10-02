//
//  Pagamento.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Ribeiro Noronha on 02/10/25.
//
import Foundation
struct Pagamento: Codable, Identifiable {
    let id: UUID
    let pedidoId: UUID
    let status: PagamentoStatus
    let metodo: metodo
    let urlDocumento: String?
    let dataPagamento: Date?
}

enum PagamentoStatus: String, Codable {
    case pendente = "PENDENTE"
    case pago = "PAGO"
    case vencido = "VENCIDO"
}

enum metodo: String, Codable {
    case boleto = "BOLETO"
    case pix = "PIX"
    case cartaoDeCredito = "CARTAO_DE_CREDITO"
    case cartaoDebito = "CARTAO_DE_DEBITO"
}
