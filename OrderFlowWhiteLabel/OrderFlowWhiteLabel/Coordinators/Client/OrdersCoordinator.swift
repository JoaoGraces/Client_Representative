//
//  OrdersCoordinator.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Eduardo on 03/11/25.
//

import SwiftUI

enum OrdersRoute: Hashable {
    case confirmShipping(order: Pedido, user: User)
    case details(order: Pedido, user: User)
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
    
    func makeOrderDetailsViewModel(order: Pedido, user: User) -> some OrderDetailsViewModeling {
        return OrderDetailsViewModel(coordinator: self, pedido: order, user: user)
    }
     
    @ViewBuilder
    func makeView(to route: OrdersRoute) -> some View {
        switch route {
        case .details(let order, let user):
            OrderDetails(viewModel: makeOrderDetailsViewModel(order: order, user: user))
        case .confirmShipping(order: let order, user: let user):
            EmptyView()
        }
    }
    
    @ViewBuilder
    func makeStartView() -> some View {
        let viewModel = MyOrdersViewModel(coordinator: self)
        MyOrdersView(viewModel: viewModel)
    }
}
