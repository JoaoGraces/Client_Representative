//
//  ItemPedido.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Ribeiro Noronha on 02/10/25.
//
import Foundation

struct ItemPedido: Codable, Identifiable {
    var id: UUID { produtoId }
    
    let pedidoId: UUID
    let produtoId: UUID
    let quantidade: Int
    let precoUnitarioMomento: Decimal
}
