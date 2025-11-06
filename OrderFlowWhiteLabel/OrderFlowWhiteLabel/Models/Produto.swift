//
//  Produto.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Ribeiro Noronha on 02/10/25.
//

import Foundation

import Foundation

struct ProductModel: Codable, Identifiable, Equatable {
    let id: UUID
    let distribuidoraId: UUID
    let name: String
    let description: String
    let price: Float
    let stock: Int
    
    let imageName: String
    let tagText: String
    
    var formattedPrice: String {
        String(format: "R$ %.2f", price)
    }
    
    var isOutOfStock: Bool {
        stock <= 0
    }
}
