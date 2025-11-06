//
//  CartItemModel.swift
//  OrderFlowWhiteLabel
//
//  Created by João Victor Bernardes Gracês on 06/11/25.
//

import Foundation

struct CartItemModel: Identifiable, Equatable, Hashable {
    let id = UUID()
    let product: Produto
    var quantity: Int
    var price: Double { Double(self.quantity) * self.product.precoUnidade}
}
