//
//  OrderDetailsViewModel.swift
//  OrderFlowWhiteLabel
//
//  Created by Scarllet Gomes on 06/11/25.
//

import Foundation
import SwiftUI

protocol OrderDetailsViewModeling: ObservableObject {
    var order: Pedido { get set }
    var itens: [ItemPedido] { get }
    var produtos: [Produto] { get }
    
    var empresa: Empresa? { get set }
    var usuario: User? { get set }
    var viewState: ViewState { get }
    
    func calculateTotal() -> Double
    func fetchPipeline() async
    func cancelOrder()
}

@Observable
class OrderDetailsViewModel: OrderDetailsViewModeling {
    var itens: [ItemPedido] = []
    var produtos: [Produto] = []
    var order: Pedido
    var empresa: Empresa?
    var usuario: User?
    
    var viewState: ViewState = .new
    
    private let coordinator: OrdersCoordinator
    private let fireStoreManager  = FirestoreManager.shared
    
    init(coordinator: OrdersCoordinator, pedido: Pedido) {
        self.coordinator = coordinator
        self.order = pedido
    }
    
    func fetchPipeline() async {
        do {
            try await fetchOrder()
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
    
    func cancelOrder() {
        //TODO: Fazer chamada do FireBase
    }
    
    private func fetchOrder() async throws {
        let itemPedidoMock = ItemPedido(pedidoId: UUID(), produtoId: UUID(), quantidade: 2, precoUnitarioMomento: 10.50)
        
        self.produtos = order.produtos
        self.itens = order.produtos.map { item in
            ItemPedido(pedidoId: order.id, produtoId: item.id, quantidade: item.quantidade, precoUnitarioMomento: Decimal(item.precoUnidade))
        }
    }
    
    private func fetchOrderMock() async throws {
        let pedidoMock = Pedido(id: UUID(), empresaClienteId: UUID(), usuarioCriadorId: UUID(), representanteId: UUID(), status: .alteracao, dataEntregaSolicitada: Date(), dataVencimentoPagamento: Date(), statusRecebimento: .conforme, observacoesCliente: "sei la", dataCriacao: Date(), produtos: [], taxaEntrega: 10.0)
        
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
    
    private func fetchUsuario() async throws {
        Task {
            let email: String = await OrderFlowCache.shared.value(forKey: .email) as? String ?? ""
            do {
                let user = try await fireStoreManager.getUserLogged(email: email)
                self.usuario = user
            } catch {
                print("Erro ao puxar user em orderDetail")
            }
        }
        
    }
}
