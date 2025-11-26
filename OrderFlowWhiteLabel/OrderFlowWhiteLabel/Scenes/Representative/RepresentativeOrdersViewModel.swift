//
//  Untitled.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Ribeiro Noronha on 06/11/25.
//
import Foundation
import SwiftUI

@Observable
class RepresentativeOrdersViewModel: MyOrdersViewModeling {
    
    var orders: [Pedido] = []
    var viewState: ViewState = .new
    var empresa: Empresa?
    var item: ItemPedido?
    var usuario: Usuario?
    
    private weak var coordinator: RepresentativeOrdersNavigation?
    
    init(coordinator: RepresentativeOrdersNavigation?) {
        self.coordinator = coordinator
    }
    
    // Ação de navegação
    @MainActor
    func goToDetails(order: Pedido) {
        coordinator?.goToDetails(order: order)
    }
    
    @MainActor
    func goToValidate(order: Pedido) {
        coordinator?.goToValidate(order: order)
    }
    
    
    func fetchPipeline() async {
        guard viewState == .new else { return } // Evita recarregar
        viewState = .loading
        
        do {
            // Simula uma chamada de rede
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 segundo
            
            try await fetchOrders()
            try await fetchCompany()
            try await fetchUsuario()
            
            self.viewState = .loaded
        } catch {
            self.viewState = .error
        }
    }
    
    private func fetchOrders() async throws {
        let pedidoMock = Pedido(id: UUID(), empresaClienteId: UUID(), usuarioCriadorId: UUID(), representanteId: UUID(), status: .alteracao, dataEntregaSolicitada: Date(), dataVencimentoPagamento: Date(), statusRecebimento: .conforme, observacoesCliente: "sei la", dataCriacao: Date())
        let pedidoMock2 = Pedido(id: UUID(), empresaClienteId: UUID(), usuarioCriadorId: UUID(), representanteId: UUID(), status: .cancelamento, dataEntregaSolicitada: Date(), dataVencimentoPagamento: Date(), statusRecebimento: .conforme, observacoesCliente: "sei la2", dataCriacao: Date())
        let pedidoMock3 = Pedido(id: UUID(), empresaClienteId: UUID(), usuarioCriadorId: UUID(), representanteId: UUID(), status: .enviado, dataEntregaSolicitada: Date(), dataVencimentoPagamento: Date(), statusRecebimento: .conforme, observacoesCliente: "sei la3", dataCriacao: Date())
        
        // MOCK 4: Pedido com status 'criado'
        let pedidoMock4 = Pedido(id: UUID(), empresaClienteId: UUID(), usuarioCriadorId: UUID(), representanteId: UUID(),
                                 status: .criado,
                                 dataEntregaSolicitada: Date(), dataVencimentoPagamento: Date(),
                                 
                                 
                                 statusRecebimento: nil,
                                 
                                 observacoesCliente: "sei la4", dataCriacao: Date())
        
        self.orders = [pedidoMock, pedidoMock2, pedidoMock3, pedidoMock4]
        self.item = ItemPedido(pedidoId: UUID(), produtoId: UUID(), quantidade: 2, precoUnitarioMomento: 10.50)
    }
    
    private func fetchCompany() async throws {
        self.empresa = Empresa(id: UUID(), razaoSocial: "Empresa Teste", nomeFantasia: "Nome Fantasia", cnpj: "123.1323/321", tipo: .clienteFinal, distribuidoraPaiId: UUID())
    }
    
    private func fetchUsuario() async throws {
        self.usuario = Usuario(id: UUID(), nomeCompleto: "Nome completo", senha_hash: "Senha", email: "email.com", papel: .adminCliente, empresaId: UUID(), dataCriacao: Date())
    }
}
