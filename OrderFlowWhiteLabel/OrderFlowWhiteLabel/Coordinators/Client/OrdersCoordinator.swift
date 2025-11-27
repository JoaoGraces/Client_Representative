//
//  OrdersCoordinator.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Eduardo on 03/11/25.
//

import SwiftUI

enum OrdersRoute: Hashable {
    case details(order: Pedido)
    case validate(order: Pedido, user: User)
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
    
   /* func makeValidadeOrderViewViewModel(order: Pedido, user: User) -> some ValidadeOrderViewModeling {
        return ValidadeOrderViewModel(coordinator: self, pedido: order, user: user)
    } */
     
    @ViewBuilder
    func makeView(to route: OrdersRoute) -> some View {
        switch route {
        case .details(let order):
            OrderDetails(viewModel: makeOrderDetailsViewModel(order: order))
        case .validate(let order, let user):
            EmptyView()
         //   ValidadeOrderView(viewModel: makeValidadeOrderViewViewModel(order: order, user: user))
        }
    }
    
    @ViewBuilder
    func makeStartView() -> some View {
        let viewModel = MyOrdersViewModel(coordinator: self)
        MyOrdersView(viewModel: viewModel)
    }
}
