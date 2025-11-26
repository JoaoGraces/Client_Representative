//
//  Untitled.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Ribeiro Noronha on 06/11/25.
//

import Foundation

protocol RepresentativeOrdersNavigation: AnyObject {
    @MainActor
    func goToDetails(order: Pedido)
    
    @MainActor
    func goToValidate(order: Pedido)
}
