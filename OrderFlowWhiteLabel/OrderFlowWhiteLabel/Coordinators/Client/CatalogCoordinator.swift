//
//  CatalogCoordinator.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Eduardo on 03/11/25.
//

import SwiftUI

enum CatalogRoute: Hashable {
}

@MainActor
final class CatalogCoordinator: ObservableObject {
    @Published var navigationStack = NavigationPath()
     
    func go(to route: CatalogRoute) {
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
    
//    func makeCatalogViewModel() -> some CatalogViewModeling {
//        return CatalogViewModel(coordinator: self)
//    }
     
    @ViewBuilder
    func makeView(to route: CatalogRoute) -> some View {
        switch route {
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    func makeStartView(viewModel: ProductListViewModel) -> some View {
        CatalogListView(viewModel: viewModel)
    }
}
