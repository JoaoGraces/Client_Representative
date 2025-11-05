//
//  OrdersCoordinator.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Eduardo on 03/11/25.
//

import SwiftUI

enum OrdersRoute: Hashable {
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
    
//    func makeOrdersViewModel() -> some OrdersViewModeling {
//        return OrdersViewModel(coordinator: self)
//    }
     
    @ViewBuilder
    func makeView(to route: OrdersRoute) -> some View {
        switch route {
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    func makeStartView() -> some View {
//        let viewModel = makeOrdersViewModel()
//        OrdersView(viewModel: viewModel)
        Text("Orders")
    }
}
