//
//  CartCoordinator.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Eduardo on 03/11/25.
//

import SwiftUI

enum CartRoute: Hashable {
}

@MainActor
final class CartCoordinator: ObservableObject {
    @Published var navigationStack = NavigationPath()
     
    func go(to route: CartRoute) {
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
    
//    func makeCartViewModel() -> some CartViewModeling {
//        return CartViewModel(coordinator: self)
//    }
     
    @ViewBuilder
    func makeView(to route: CartRoute) -> some View {
        switch route {
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    func makeStartView() -> some View {
//        let viewModel = makeCartViewModel()
//        CartView(viewModel: viewModel)
        Text("Cart")
    }
}
