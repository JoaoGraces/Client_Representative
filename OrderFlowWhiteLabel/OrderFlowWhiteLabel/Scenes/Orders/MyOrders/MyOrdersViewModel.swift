//
//  MyOrdersViewModel.swift
//  OrderFlowWhiteLabel
//
//  Created by Scarllet Gomes on 06/11/25.
//

//TODO: Lidar com o erro
//TODO: Fazer requisições no firebase
//TODO: Navegação

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

@Observable
class MyOrdersViewModel: MyOrdersViewModeling {
    
    var orders: [Pedido] = []
    var viewState: ViewState = .new
    
    var empresa: Empresa?
    var item: ItemPedido?
    var usuario: User?
    
    private let coordinator: OrdersCoordinator
    private let orderService: OrderService = OrderService.shared
    private let fireStoreManager: FirestoreManager = FirestoreManager.shared
    
    init(coordinator: OrdersCoordinator) {
        self.coordinator = coordinator
    }
    
    @MainActor
    func goToDetails(order: Pedido) {
        guard let usuario else {
            viewState = .error
            return
        }
        coordinator.go(to: .details(order: order, user: usuario))
    }
    
    func fetchPipeline() async {
        do {
            try await fetchOrders()
        } catch {
            self.viewState = .error
        }
        
        do {
            try await fetchUser()
        } catch {
            self.viewState = .error
        }
        
        self.viewState = .loaded
    }
    
    private func fetchOrders() async throws {
        Task {
            let email: String = await OrderFlowCache.shared.value(forKey: .email) as? String ?? ""
            
            do {
               let orders = try await orderService.fetchClientOrders(forUserEmail: email)
                self.orders = orders
            } catch {
                self.viewState = .error
            }
        }
    }
    
    private func fetchUser() async throws {
        Task {
            let email: String = await OrderFlowCache.shared.value(forKey: .email) as? String ?? ""
            
            do {
                let user = try await fireStoreManager.getUserLogged(email: email)
                self.usuario = user
            } catch {
                self.viewState = .error
            }
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
