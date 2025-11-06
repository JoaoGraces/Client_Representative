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
    var empresa: Empresa? { get set }
    var item: ItemPedido? { get set }
    
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
    var usuario: Usuario?
    
    private let coordinator: OrdersCoordinator
    
    init(coordinator: OrdersCoordinator) {
        self.coordinator = coordinator
    }
    
    @MainActor
    func goToDetails(order: Pedido) {
        coordinator.go(to: .details(order: order))
    }
    
    func fetchPipeline() async {
        do {
            try await fetchOrders()
        } catch {
            self.viewState = .error
        }
        
        do {
            try await fetchCompany()
        } catch {
            self.viewState = .error
        }
        
        do {
            try await fetchUsuario()
        } catch {
            self.viewState = .error
        }
        
        self.viewState = .loaded
    }
    
    private func fetchOrders() async throws {
        let pedidoMock = Pedido(id: UUID(), empresaClienteId: UUID(), usuarioCriadorId: UUID(), representanteId: UUID(), status: .alteracao, dataEntregaSolicitada: Date(), dataVencimentoPagamento: Date(), statusRecebimento: .conforme, observacoesCliente: "sei la", dataCriacao: Date())
        let pedidoMock2 = Pedido(id: UUID(), empresaClienteId: UUID(), usuarioCriadorId: UUID(), representanteId: UUID(), status: .cancelamento, dataEntregaSolicitada: Date(), dataVencimentoPagamento: Date(), statusRecebimento: .conforme, observacoesCliente: "sei la2", dataCriacao: Date())
        let pedidoMock3 = Pedido(id: UUID(), empresaClienteId: UUID(), usuarioCriadorId: UUID(), representanteId: UUID(), status: .enviado, dataEntregaSolicitada: Date(), dataVencimentoPagamento: Date(), statusRecebimento: .conforme, observacoesCliente: "sei la3", dataCriacao: Date())
        
        self.orders = [pedidoMock, pedidoMock2, pedidoMock3, pedidoMock]
        
        let itemPedidoMock = ItemPedido(pedidoId: UUID(), produtoId: UUID(), quantidade: 2, precoUnitarioMomento: 10.50)
       
        self.item = itemPedidoMock
    }
    
    private func fetchCompany() async throws {
        let empresaMock = Empresa(id: UUID(), razaoSocial: "Empresa Teste", nomeFantasia: "Nome Fantasia", cnpj: "123.1323/321", tipo: .clienteFinal, distribuidoraPaiId: UUID())
        self.empresa = empresaMock
    }
    
    private func fetchUsuario() async throws {
        let usuarioMock = Usuario(id: UUID(), nomeCompleto: "Nome completo", senha_hash: "Senha", email: "email.com", papel: .adminCliente, empresaId: UUID(), dataCriacao: Date())
        self.usuario = usuarioMock
    }
    
}

