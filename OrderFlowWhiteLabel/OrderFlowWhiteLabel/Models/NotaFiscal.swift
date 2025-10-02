//
//  NotaFiscal.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Ribeiro Noronha on 02/10/25.
//
import Foundation

struct NotaFiscal: Codable, Identifiable {
    let id: UUID
    let pedidoId: UUID
    let numeroNota: String
    let urlPdf: String
    let dataEmissao: Date
}
