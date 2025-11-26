//
//  MainCoordinator.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Eduardo on 03/11/25.
//

import SwiftUI

enum AuthRoute: Hashable {
    case register
    case login
}

@MainActor
final class AuthCoordinator: ObservableObject {
    @Published var navigationStack = NavigationPath()
    weak var rootCoordinator: RootCoordinator?
    @Published var root: AuthRoute = .login
    
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
    
    func switchTo(route: AuthRoute) {
        withAnimation {
            navigationStack = NavigationPath()
            root = route
        }
    }
    
    func completeAuthentication(role: UserRole) {
        rootCoordinator?.completeAuthentication(role: role)
    }
    
    func makeRegisterViewModel() -> some RegisterViewModeling {
        return RegisterViewModel(coordinator: self)
    }
    
    func makeLoginViewModel() -> some LoginViewModeling {
        return LoginViewModel(coordinator: self)
    }
    
    @ViewBuilder
    func makeView(to route: AuthRoute) -> some View {
        switch route {
        case .register:
            let viewModel = makeRegisterViewModel()
            RegisterView(viewModel: viewModel)
        case .login:
            let viewModel = makeLoginViewModel()
            LoginView(viewModel: viewModel)
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
            coordinator.makeView(to: coordinator.root)
                .navigationDestination(for: AuthRoute.self) { route in
                    coordinator.makeView(to: route)
                }
        }
    }
}
