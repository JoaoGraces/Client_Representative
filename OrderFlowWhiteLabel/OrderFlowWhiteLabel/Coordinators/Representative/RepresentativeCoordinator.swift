//
//  RepresentativeCoordinator.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Eduardo on 03/11/25.
//

import SwiftUI

// (O enum RepresentativeRoute está 100% correto e não muda)
enum RepresentativeRoute: Hashable {
    case cancelamento(Pedido)
    case enviado(Pedido)
    case alteracao(Pedido)
    case novoPedido(Pedido, User)
}

@MainActor
final class RepresentativeCoordinator: ObservableObject {
    @Published var navigationStack = NavigationPath()
    private lazy var ordersViewModel: RepresentativeOrdersViewModel = {
            return RepresentativeOrdersViewModel(coordinator: self)
        }()
    func go(to route: RepresentativeRoute) { navigationStack.append(route) }
    func back() { if !navigationStack.isEmpty { navigationStack.removeLast() } }
    func backToRoot() { if !navigationStack.isEmpty { navigationStack = NavigationPath() } }
     
    
    @ViewBuilder
    func makeView(to route: RepresentativeRoute) -> some View {
        switch route {
        case .cancelamento(let pedido):
            CancellationView()
             
        case .enviado(let pedido):
            let viewModel = RepresentativeOrderDetailsViewModel(
                coordinator: self,
                pedido: pedido
            )
            RepresentativeOrderDetailsView(viewModel: viewModel)
             
        case .alteracao(let pedido):
            ModificationAuthorizationView()
             
        case .novoPedido(let pedido, let user):
            let viewModel = ValidadeOrderViewModel(coordinator: self, pedido: pedido, user: user)
            ValidadeOrderView(viewModel: viewModel)
        }
    }
     
     
    @ViewBuilder
    func makeStartView() -> some View {
        RepresentativeOrdersView(viewModel: self.ordersViewModel)
    }
}

extension RepresentativeCoordinator: RepresentativeOrdersNavigation, RepresentativeOrderDetailsNavigation {
    
    @MainActor
    func goToDetails(order: Pedido) {
        go(to: .enviado(order))
    }
     
    @MainActor
    func goToValidate(order: Pedido, user: User) {
         
        switch order.status {
        case .cancelamento:
            go(to: .cancelamento(order))
        case .enviado:
            go(to: .enviado(order))
        case .alteracao:
            go(to: .alteracao(order))
        case .criado:
            go(to: .novoPedido(order, user))
        default:
            go(to: .enviado(order))
        }
    }

    
    @MainActor
    func requestUpdate(order: Pedido) {
    
        print("Coordenador: Navegando para .alteracao")
        go(to: .alteracao(order))
    }
    
    @MainActor
    func requestCancel(order: Pedido) {
        print("Coordenador: Navegando para .cancelamento")
        go(to: .cancelamento(order))
    }
}

struct RepresentativeCoordinatorView: View {
    @StateObject private var coordinator = RepresentativeCoordinator()
    var onLogout: () -> Void
    var body: some View {
        TabView {
            RepresentativeClientsView(didFinish: onLogout)
                .tabItem {
                    Label("Clientes", systemImage: "person.2.crop.square.stack")
                }
            
            NavigationStack(path: $coordinator.navigationStack) {
                coordinator.makeStartView()
                    .navigationDestination(for: RepresentativeRoute.self) { route in
                        coordinator.makeView(to: route)
                    }
            }
            .tabItem {
                Label("Pedidos", systemImage: "list.clipboard")
            }
        }
        .tint(DS.Colors.blueBase)
    }
}

/***#Preview {
    RepresentativeCoordinatorView(onLogout: () -> Void)
}***/
