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
    var onSeeMyOrders: () -> Void = { }
    var onSeeCatalog: () -> Void = { }
    
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
                      deliveryFee: Double.random(in: 0...30),
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
                        Task { @MainActor in
                            await Task.yield()   // Deixa o layout estabilizar
                            self.onSeeCatalog()
                        }
                        self.backToRoot()
                        self.viewModel?.clearCart()
                   
        
                    },
                    onSeeMyOrders: {
                        Task { @MainActor in
                            await Task.yield()   // Deixa o layout estabilizar
                            self.onSeeMyOrders()
                        }
                        self.backToRoot()
                        self.viewModel?.clearCart()
                   
                    }
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
