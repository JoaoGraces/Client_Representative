//
//  MainCoordinator.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Eduardo on 03/11/25.
//

import SwiftUI

enum NavigationRoute: Hashable {
    case register
}

@MainActor
final class MainCoordinator: ObservableObject {
    @Published var navigationStack = NavigationPath()
    
    func go(to route: NavigationRoute) {
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
    
    func makeRegisterViewModel() -> some RegisterViewModeling {
        return RegisterViewModel()
    }
    
    @ViewBuilder
    func makeView(to route: NavigationRoute) -> some View {
        switch route {
        case .register:
            let viewModel = makeRegisterViewModel()
            RegisterView(viewModel: viewModel)
        }
    }
}

struct MainCoordinatorView: View {
    @StateObject private var coordinator = MainCoordinator()

    var body: some View {
        NavigationStack(path: $coordinator.navigationStack) {
            coordinator.makeView(to: .register)
                .navigationDestination(for: NavigationRoute.self) { route in
                    coordinator.makeView(to: route)
                }
        }
        .environmentObject(coordinator)
    }
}
