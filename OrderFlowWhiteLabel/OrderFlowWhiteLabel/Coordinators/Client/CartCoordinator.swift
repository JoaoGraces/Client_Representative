//
//  CartCoordinator.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Eduardo on 03/11/25.
//

import SwiftUI

enum CartRoute: Hashable {
    case checkout(products: [CartItemModel])
    case orderConfirmation(OrderConfirmation)
}

@MainActor
final class CartCoordinator: ObservableObject {
    @Published var navigationStack = NavigationPath()
    private(set) var viewModel: ProductListViewModel?
    
    func start(with viewModel: ProductListViewModel) {
          self.viewModel = viewModel
      }
    
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
     
    @ViewBuilder
    func makeView(to route: CartRoute) -> some View {
        switch route {
        case .checkout(let products):
            if let viewModel = viewModel {
                  CheckoutView(
                      items: products,
                      deliveryFee: 7.50,
                      coordinator: self,
                      viewModel: viewModel
                  )
              } else {
                  Text("Erro: ViewModel não inicializada")
                      .foregroundColor(.red)
              }
        case .orderConfirmation(let confirmation):
            OrderSentView(
                viewModel: OrderSentViewModel(
                    data: confirmation,
                    onBackToCatalog: {
                        self.backToRoot()
                        self.viewModel?.clearCart()
                    },
                    onSeeMyOrders: { /* ação futura */ }
                )
            )
        default:
            EmptyView()
        }
    }
    
    //@ViewBuilder
    func makeStartView(viewModel: ProductListViewModel) -> some View {
        // chama antes de construir a view
        start(with: viewModel)
        
        // retorna a view
        return CartListView(viewModel: viewModel, coordinator: self)
    }
}
