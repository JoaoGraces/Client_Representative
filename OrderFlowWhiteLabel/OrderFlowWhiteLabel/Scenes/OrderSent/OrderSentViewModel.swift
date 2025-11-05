//
//  OrderSentViewModel.swift
//  OrderFlowWhiteLabel
//
//  Created by Mirelle Alves Sine on 04/11/25.
//

import SwiftUI

import Foundation

final class OrderSentViewModel: ObservableObject {

    private let data: OrderConfirmation
    let orderIdText: String
    let dateString: String
    let statusText: String
    let itemsCountText: String
    let totalText: String

    private let onBackToCatalog: () -> Void
    private let onSeeMyOrders: () -> Void

    init(
        data: OrderConfirmation,
        onBackToCatalog: @escaping () -> Void = {},
        onSeeMyOrders: @escaping () -> Void = {}
    ) {
        self.data = data
        self.onBackToCatalog = onBackToCatalog
        self.onSeeMyOrders = onSeeMyOrders

        self.orderIdText = data.orderIdText
        self.dateString = data.dataString
        self.statusText = data.statusText
        self.itemsCountText = data.itensCountText
        self.totalText = "R$ \(data.total.formattedMoney)"
    }

    func handleBackToCatalog() { onBackToCatalog() }
    func handleSeeMyOrders() { onSeeMyOrders() }
}
