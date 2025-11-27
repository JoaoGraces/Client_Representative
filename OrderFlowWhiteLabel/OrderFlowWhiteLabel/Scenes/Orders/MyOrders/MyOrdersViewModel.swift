//
//  MyOrdersViewModel.swift
//  OrderFlowWhiteLabel
//
//  Created by Scarllet Gomes on 06/11/25.
//

import Foundation
import SwiftUI

protocol MyOrdersViewModeling: ObservableObject {
    var orders: [Pedido] { get set }
    var item: ItemPedido? { get set }
    var usuario: User? { get set}
    
    var viewState: ViewState { get }
    
    func fetchPipeline() async
    
    @MainActor
    func goToDetails(order: Pedido)
}

enum ViewState {
    case new
    case loading
    case loaded
    case error
}

class MyOrdersViewModel: MyOrdersViewModeling {
    @Published var orders: [Pedido] = []
    @Published var viewState: ViewState = .new
    
    @Published var empresa: Empresa?
    @Published var item: ItemPedido?
    @Published var usuario: User?
    
    private let coordinator: OrdersCoordinator
    private let orderService: OrderService = OrderService.shared
    private let fireStoreManager: FirestoreManager = FirestoreManager.shared
    
    init(coordinator: OrdersCoordinator) {
        self.coordinator = coordinator
    }
    
    @MainActor
    func goToDetails(order: Pedido) {
        guard let usuario = self.usuario else {
            return
        }
        coordinator.go(to: .details(order: order, user: usuario))
    }
    
    func fetchPipeline() async {
        if orders.isEmpty {
            await MainActor.run { viewState = .loading }
        }
        do {
            try await fetchOrders()
            try await fetchUser()
            
            await MainActor.run {
                self.viewState = .loaded
            }
        } catch {
            print("Erro no pipeline: \(error)")
            await MainActor.run {
                self.viewState = .error
            }
        }
    }
    
    private func fetchOrders() async throws {
        let email: String = await OrderFlowCache.shared.value(forKey: .email) as? String ?? ""
        
        let fetchedOrders = try await orderService.fetchClientOrders(forUserEmail: email)
        
        await MainActor.run {
            self.orders = fetchedOrders
        }
        
    }
    
    private func fetchUser() async throws {
        let email: String = await OrderFlowCache.shared.value(forKey: .email) as? String ?? ""
        let fetchedUser = try await fireStoreManager.getUserLogged(email: email)
        
        await MainActor.run {
            self.usuario = fetchedUser
        }
    }
}

// Mocks
extension MyOrdersViewModel {
    private func fetchOrdersMock() async throws {
        let pedidoMock = Pedido(id: UUID(), empresaClienteId: UUID(), usuarioCriadorId: UUID(), representanteId: UUID(), status: .alteracao, dataEntregaSolicitada: Date(), dataVencimentoPagamento: Date(), statusRecebimento: .conforme, observacoesCliente: "sei la", dataCriacao: Date(), produtos: [], taxaEntrega: 10.0)
        let pedidoMock2 = Pedido(id: UUID(), empresaClienteId: UUID(), usuarioCriadorId: UUID(), representanteId: UUID(), status: .cancelamento, dataEntregaSolicitada: Date(), dataVencimentoPagamento: Date(), statusRecebimento: .conforme, observacoesCliente: "sei la2", dataCriacao: Date(), produtos: [], taxaEntrega: 10.0)
        let pedidoMock3 = Pedido(id: UUID(), empresaClienteId: UUID(), usuarioCriadorId: UUID(), representanteId: UUID(), status: .enviado, dataEntregaSolicitada: Date(), dataVencimentoPagamento: Date(), statusRecebimento: .conforme, observacoesCliente: "sei la3", dataCriacao: Date(), produtos: [], taxaEntrega: 10.0)
        
        self.orders = [pedidoMock, pedidoMock2, pedidoMock3, pedidoMock]
        
        let itemPedidoMock = ItemPedido(pedidoId: UUID(), produtoId: UUID(), quantidade: 2, precoUnitarioMomento: 10.50)
        
        self.item = itemPedidoMock
    }
}


extension Double {
    var twoDecimals: String {
        String(format: "%.2f", self)
    }
}
