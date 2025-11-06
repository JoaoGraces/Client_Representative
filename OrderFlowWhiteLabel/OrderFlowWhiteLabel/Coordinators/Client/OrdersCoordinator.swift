//
//  OrdersCoordinator.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Eduardo on 03/11/25.
//

import SwiftUI

enum OrdersRoute: Hashable {
    case details(order: Pedido)
    case validate
}

@MainActor
final class OrdersCoordinator: ObservableObject {
    @Published var navigationStack = NavigationPath()
     
    func go(to route: OrdersRoute) {
        navigationStack.append(route)
    }
     
    func back() {
        if !navigationStack.isEmpty {
            navigationStack.removeLast()
        }
    }
     
    func backToRoot() {
        if !navigationStack.isEmpty {
            navigationStack = NavigationPath()
        }
    }
    
    func makeOrderDetailsViewModel(order: Pedido) -> some OrderDetailsViewModeling {
        return OrderDetailsViewModel(coordinator: self, pedido: order)
    }
     
    @ViewBuilder
    func makeView(to route: OrdersRoute) -> some View {
        switch route {
        case .details(let order):
            OrderDetails(viewModel: makeOrderDetailsViewModel(order: order))
        case .validate:
            EmptyView()
        }
    }
    
    @ViewBuilder
    func makeStartView() -> some View {
        let viewModel = MyOrdersViewModel(coordinator: self)
        MyOrdersView(viewModel: viewModel)
    }
}
