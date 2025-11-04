//
//  MainCoordinator.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Eduardo on 03/11/25.
//

import SwiftUI

enum AuthRoute: Hashable {
    case register
}

@MainActor
final class AuthCoordinator: ObservableObject {
    @Published var navigationStack = NavigationPath()
    weak var rootCoordinator: RootCoordinator?
    
    init(rootCoordinator: RootCoordinator?) {
        self.rootCoordinator = rootCoordinator
    }
    
    func go(to route: AuthRoute) {
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
    
    func completeAuthentication() {
        rootCoordinator?.completeAuthentication()
    }
    
    func makeRegisterViewModel() -> some RegisterViewModeling {
        return RegisterViewModel(coordinator: self)
    }
    
    @ViewBuilder
    func makeView(to route: AuthRoute) -> some View {
        switch route {
        case .register:
            let viewModel = makeRegisterViewModel()
            RegisterView(viewModel: viewModel)
        }
    }
}

struct AuthCoordinatorView: View {
    @StateObject private var coordinator: AuthCoordinator
    
    init(rootCoordinator: RootCoordinator) {
        _coordinator = StateObject(wrappedValue: AuthCoordinator(rootCoordinator: rootCoordinator))
    }

    var body: some View {
        NavigationStack(path: $coordinator.navigationStack) {
            coordinator.makeView(to: .register)
                .navigationDestination(for: AuthRoute.self) { route in
                    coordinator.makeView(to: route)
                }
        }
    }
}
