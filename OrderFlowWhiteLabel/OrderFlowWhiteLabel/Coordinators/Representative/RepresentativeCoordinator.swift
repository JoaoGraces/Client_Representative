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
    case novoPedido
     
    func hash(into hasher: inout Hasher) {
        switch self {
        case .cancelamento(let p): hasher.combine("c"); hasher.combine(p.id)
        case .enviado(let p): hasher.combine("e"); hasher.combine(p.id)
        case .alteracao(let p): hasher.combine("a"); hasher.combine(p.id)
        case .novoPedido: hasher.combine("n")
        }
    }
    static func == (lhs: RepresentativeRoute, rhs: RepresentativeRoute) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

@MainActor
final class RepresentativeCoordinator: ObservableObject {
    @Published var navigationStack = NavigationPath()
     
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
             
        case .novoPedido:
            NewOrderView() // Placeholder
        }
    }
     
     
    @ViewBuilder
    func makeStartView() -> some View {
        let viewModel = RepresentativeOrdersViewModel(coordinator: self)
         
        RepresentativeOrdersView(viewModel: viewModel)
    }
}

extension RepresentativeCoordinator: RepresentativeOrdersNavigation, RepresentativeOrderDetailsNavigation {
     
    @MainActor
    func goToDetails(order: Pedido) {
        go(to: .enviado(order))
    }
     
    @MainActor
    func goToValidate(order: Pedido) {
         
        switch order.status {
        case .cancelamento:
            go(to: .cancelamento(order))
        case .enviado:
            go(to: .enviado(order))
        case .alteracao:
            go(to: .alteracao(order))
        case .criado:
            go(to: .novoPedido)
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
     
    var body: some View {
        NavigationStack(path: $coordinator.navigationStack) {
            coordinator.makeStartView()
                .navigationDestination(for: RepresentativeRoute.self) { route in
                    coordinator.makeView(to: route)
                }
        }
    }
}

#Preview {
    RepresentativeCoordinatorView()
}
