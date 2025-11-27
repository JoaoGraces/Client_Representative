//
//  MyOrdersViewModel.swift
//  OrderFlowWhiteLabel
//
//  Created by Scarllet Gomes on 06/11/25.
//

import Foundation
import SwiftUI

protocol ValidadeOrderViewModeling: ObservableObject {
    var order: Pedido { get set }
    var itens: [ItemPedido] { get }
    var produtos: [Produto] { get }
    var usuario: User { get }
    
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
    var usuario: User
    
    private let coordinator: RepresentativeCoordinator
    
    init(coordinator: RepresentativeCoordinator, pedido: Pedido, user: User) {
        self.coordinator = coordinator
        self.order = pedido
        self.usuario = user
    }
    
    @MainActor
    func goToDetails(order: Pedido) {
        // coordinator.go(to: .details(order: order))
        self.order = order
    }
    
    func fetchPipeline() async {
        prepateData()
        
        self.viewState = .loaded
    }
    
    func calculateTotal() -> Double {
        return itens.reduce(0) { $0 + $1.valorTotal }
    }
    
    
    func aproveOrder() {
        Task {
            do {
                // Chama o Singleton do FirestoreManager
                try await FirestoreManager.shared.updateOrderStatus(
                    forUserEmail: self.usuario.email,
                    orderId: self.order.id,
                    newStatus: .aprovado
                )
                
                await MainActor.run {
                    self.order.status = .aprovado
                    self.viewState = .loaded
                    print("✅ Pedido aprovado com sucesso via Manager")
                }
            } catch {
                await MainActor.run {
                    print("❌ Erro ao aprovar: \(error.localizedDescription)")
                     self.viewState = .error
                }
            }
        }
    }
    
    func rejectOrder() {
        // Opcional: self.viewState = .loading
        
        Task {
            do {
                // Chama o Singleton do FirestoreManager
                try await FirestoreManager.shared.updateOrderStatus(
                    forUserEmail: self.usuario.email,
                    orderId: self.order.id,
                    newStatus: .rejeitado
                )
                
                await MainActor.run {
                    self.order.status = .rejeitado
                    self.viewState = .loaded
                    print("🚫 Pedido rejeitado com sucesso via Manager")
                }
            } catch {
                await MainActor.run {
                    print("❌ Erro ao rejeitar: \(error.localizedDescription)")
                     self.viewState = .error
                }
            }
        }
    }
    
    private func prepateData() {
        self.produtos = order.produtos
        self.itens = order.produtos.map { item in
            ItemPedido(pedidoId: order.id, produtoId: item.id, quantidade: item.quantidade, precoUnitarioMomento: Decimal(item.precoUnidade))
        }
    }
    
    private func fetchOrders() async throws {
        let pedidoMock = Pedido(id: UUID(), empresaClienteId: UUID(), usuarioCriadorId: UUID(), representanteId: UUID(), status: .alteracao, dataEntregaSolicitada: Date(), dataVencimentoPagamento: Date(), statusRecebimento: .conforme, observacoesCliente: "sei la", dataCriacao: Date(), produtos: [], taxaEntrega: 1)
        
        self.order = pedidoMock
        
        let itemPedidoMock = ItemPedido(pedidoId: UUID(), produtoId: UUID(), quantidade: 2, precoUnitarioMomento: 10.50)
        
        // CORREÇÃO 1:
        let produtoMock = Produto(
            id: UUID(), distribuidoraId: UUID(), nome: "Café",
            quantidade: 2, precoUnidade: 10.50, estoque: 10,
            imageName: "photo", // <-- Adicionado
            tagText: "-"        // <-- Adicionado
        )
        
        self.itens.append(itemPedidoMock)
        self.produtos.append(produtoMock)
        
        
        let itemPedidoMock2 = ItemPedido(pedidoId: UUID(), produtoId: UUID(), quantidade: 1, precoUnitarioMomento: 8.50)
        
        // CORREÇÃO 2:
        let produtoMock2 = Produto(
            id: UUID(), distribuidoraId: UUID(), nome: "Leite",
            quantidade: 1, precoUnidade: 8.50, estoque: 8,
            imageName: "photo", // <-- Adicionado
            tagText: "-"        // <-- Adicionado
        )
        
        self.itens.append(itemPedidoMock2)
        self.produtos.append(produtoMock2)
        
        let itemPedidoMock3 = ItemPedido(pedidoId: UUID(), produtoId: UUID(), quantidade: 8, precoUnitarioMomento: 2.70)
        
        // CORREÇÃO 3:
        let produtoMock3 = Produto(
            id: UUID(), distribuidoraId: UUID(), nome: "Repolho",
            quantidade: 8, precoUnidade: 2.70, estoque: 12,
            imageName: "photo", // <-- Adicionado
            tagText: "-"        // <-- Adicionado
        )
        
        self.itens.append(itemPedidoMock3)
        self.produtos.append(produtoMock3)
        
    }
    
    /* private func fetchUsuario() async throws {
     let usuarioMock = Usuario(id: UUID(), nomeCompleto: "Nome completo", senha_hash: "Senha", email: "email.com", papel: .adminCliente, empresaId: UUID(), dataCriacao: Date())
     self.usuario = usuarioMock
     } */
    
}

