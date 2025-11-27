//
//  ClientCoordinator.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Eduardo on 03/11/25.
//

import SwiftUI

enum ClientTab {
    case catalog
    case cart
    case orders
}

struct ClientCoordinatorView: View {
    @StateObject private var catalogCoordinator = CatalogCoordinator()
    @StateObject private var cartCoordinator = CartCoordinator()
    @StateObject private var ordersCoordinator = OrdersCoordinator()

    @StateObject private var sharedViewModel = ProductListViewModel()
    @State private var selectedTab: ClientTab = .catalog

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack(path: $catalogCoordinator.navigationStack) {
                catalogCoordinator.makeStartView(viewModel: sharedViewModel)
                    .navigationDestination(for: CatalogRoute.self) { route in
                        catalogCoordinator.makeView(to: route)
                    }
            }
            .tabItem {
                Label("Catálogo", systemImage: "house.fill")
            }
            .tag(ClientTab.catalog)
            
            NavigationStack(path: $cartCoordinator.navigationStack) {
                cartCoordinator.makeStartView(viewModel: sharedViewModel)
                    .navigationDestination(for: CartRoute.self) { route in
                        cartCoordinator.makeView(to: route)
                    }
            }
            .tabItem {
                Label("Carrinho", systemImage: "cart.fill")
            }
            .tag(ClientTab.cart)
            
            NavigationStack(path: $ordersCoordinator.navigationStack) {
                ordersCoordinator.makeStartView()
                    .navigationDestination(for: OrdersRoute.self) { route in
                        ordersCoordinator.makeView(to: route)
                    }
            }
            .tabItem {
                Label("Pedidos", systemImage: "list.bullet.rectangle.portrait.fill")
            }
            .tag(ClientTab.orders)
        }.onAppear() {
            cartCoordinator.onSeeMyOrders = {
                self.selectedTab = .orders
            }
            cartCoordinator.onSeeCatalog = {
                self.selectedTab = .catalog
            }
        }
    }
}

#Preview {
    ClientCoordinatorView()
}
