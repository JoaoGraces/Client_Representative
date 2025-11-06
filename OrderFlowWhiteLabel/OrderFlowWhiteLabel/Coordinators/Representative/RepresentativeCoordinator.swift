//
//  RepresentativeCoordinator.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Eduardo on 03/11/25.
//

import SwiftUI

enum RepresentativeRoute: Hashable {
    case cancelamento
    case enviado
    case alteracao
    case novoPedido
}

@MainActor
final class RepresentativeCoordinator: ObservableObject {
    @Published var navigationStack = NavigationPath()
     
    func go(to route: RepresentativeRoute) {
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
    
//    func makeRepresentativeViewModel() -> some RepresentativeViewModeling {
//        return RepresentativeViewModel(coordinator: self)
//    }
     
    @ViewBuilder
    func makeView(to route: RepresentativeRoute) -> some View {
        switch route {
                case .cancelamento:
                    CancellationView()
                case .enviado:
                    SentView()
                case .alteracao:
                    ModificationAuthorizationView()
                case .novoPedido:
                    NewOrderView()
                }
    }
    
    @ViewBuilder
    func makeStartView() -> some View {
//        let viewModel = makeRepresentativeViewModel()
//        RepresentativeView(viewModel: viewModel)
        MockListView(coordinator: self)
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
//            coordinator.makeView(to: )
//                .navigationDestination(for: RepresentativeRoute.self) { route in
//                    coordinator.makeView(to: route)
//                }
        }
    }
}
#Preview {
    RepresentativeCoordinatorView()
}
