//
//  RepresentativeOrderDetailsViewModel.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Ribeiro Noronha on 06/11/25.
//

import Foundation
import SwiftUI


protocol RepresentativeOrderDetailsNavigation: AnyObject {
    @MainActor
    func requestUpdate(order: Pedido)
     
    @MainActor
    func requestCancel(order: Pedido)
}

@Observable
class RepresentativeOrderDetailsViewModel: OrderDetailsViewModeling {
    
    var itens: [ItemPedido] = []
    var produtos: [Produto] = []
    var order: Pedido
    var empresa: Empresa?
    var usuario: Usuario?
    var viewState: ViewState = .new
    
    private weak var coordinator: RepresentativeOrderDetailsNavigation?
    
    init(coordinator: RepresentativeOrderDetailsNavigation?, pedido: Pedido) {
        self.coordinator = coordinator
        self.order = pedido // Recebe o pedido da navegação
    }
    
    
    func fetchPipeline() async {
        guard viewState == .new else { return }
        viewState = .loading
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seg
            try await fetchOrderItems() // Mocks
            try await fetchCompany()    // Mocks
            try await fetchUsuario()    // Mocks
            self.viewState = .loaded
        } catch {
            self.viewState = .error
        }
    }
    
    func calculateTotal() -> Double {
        return itens.reduce(0) { $0 + $1.valorTotal }
    }
    @MainActor
    func requestUpdate() {
        coordinator?.requestUpdate(order: self.order)
    }
    @MainActor
    func cancelOrder() {

        coordinator?.requestCancel(order: self.order)
    }
    
    
    private func fetchOrderItems() async throws {
        let itemPedidoMock = ItemPedido(pedidoId: UUID(), produtoId: UUID(), quantidade: 2, precoUnitarioMomento: 10.50)
        let produtoMock = Produto(id: UUID(), distribuidoraId: UUID(), nome: "Café", quantidade: 2, precoUnidade: 10.50, estoque: 10, imageName: "photo", tagText: "-")
        self.itens.append(itemPedidoMock)
        self.produtos.append(produtoMock)
    }
    private func fetchCompany() async throws {
        self.empresa = Empresa(id: UUID(), razaoSocial: "Empresa Teste", nomeFantasia: "Nome Fantasia", cnpj: "123.1323/321", tipo: .clienteFinal, distribuidoraPaiId: UUID())
    }
    private func fetchUsuario() async throws {
        self.usuario = Usuario(id: UUID(), nomeCompleto: "Nome completo", senha_hash: "Senha", email: "email.com", papel: .adminCliente, empresaId: UUID(), dataCriacao: Date())
    }
}
