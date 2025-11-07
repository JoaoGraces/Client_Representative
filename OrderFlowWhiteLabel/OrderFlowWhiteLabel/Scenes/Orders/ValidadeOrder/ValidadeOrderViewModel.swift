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

protocol ValidadeOrderViewModeling: ObservableObject {
    var order: Pedido { get set }
    var empresa: Empresa? { get set }
    var itens: [ItemPedido] { get }
    var produtos: [Produto] { get }
    
    var viewState: ViewState { get }
    
    func fetchPipeline() async
    
    func calculateTotal() -> Double
    
    func aproveOrder()
    func rejectOrder()
    
    @MainActor
    func goToDetails(order: Pedido)
}

@Observable
class ValidadeOrderViewModel: ValidadeOrderViewModeling {
    var order: Pedido
    var viewState: ViewState = .new
    
    var itens: [ItemPedido] = []
    var produtos: [Produto] = []
    var empresa: Empresa?
    var usuario: Usuario?
    
    private let coordinator: OrdersCoordinator
    
    init(coordinator: OrdersCoordinator, pedido: Pedido) {
        self.coordinator = coordinator
        self.order = pedido
    }
    
    @MainActor
    func goToDetails(order: Pedido) {
        coordinator.go(to: .details(order: order))
        self.order = order
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
    
    func calculateTotal() -> Double {
        return itens.reduce(0) { $0 + $1.valorTotal }
    }
    
    func aproveOrder() {
        
    }
    
    func rejectOrder() {
        
    }
    
    private func fetchOrders() async throws {
        let pedidoMock = Pedido(id: UUID(), empresaClienteId: UUID(), usuarioCriadorId: UUID(), representanteId: UUID(), status: .alteracao, dataEntregaSolicitada: Date(), dataVencimentoPagamento: Date(), statusRecebimento: .conforme, observacoesCliente: "sei la", dataCriacao: Date())
        
        self.order = pedidoMock
        
        let itemPedidoMock = ItemPedido(pedidoId: UUID(), produtoId: UUID(), quantidade: 2, precoUnitarioMomento: 10.50)
//        let produtoMock = Produto(id: UUID(), distribuidoraId: UUID(), nome: "Café", quantidade: 2, precoUnidade: 10.50, estoque: 10)
        
        self.itens.append(itemPedidoMock)
        //self.produtos.append(produtoMock)
        
        
        let itemPedidoMock2 = ItemPedido(pedidoId: UUID(), produtoId: UUID(), quantidade: 1, precoUnitarioMomento: 8.50)
        //let produtoMock2 = Produto(id: UUID(), distribuidoraId: UUID(), nome: "Leite", quantidade: 1, precoUnidade: 8.50, estoque: 8)
        
        self.itens.append(itemPedidoMock2)
        //self.produtos.append(produtoMock2)
        
        let itemPedidoMock3 = ItemPedido(pedidoId: UUID(), produtoId: UUID(), quantidade: 8, precoUnitarioMomento: 2.70)
        //let produtoMock3 = Produto(id: UUID(), distribuidoraId: UUID(), nome: "Repolho", quantidade: 8, precoUnidade: 2.70, estoque: 12)
        
        self.itens.append(itemPedidoMock3)
        //self.produtos.append(produtoMock3)
       
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

