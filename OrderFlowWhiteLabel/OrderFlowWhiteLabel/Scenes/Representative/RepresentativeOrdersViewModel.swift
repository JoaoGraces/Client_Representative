//
//  Untitled.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Ribeiro Noronha on 06/11/25.
//
import Foundation
import SwiftUI

protocol RepresentativeMyOrdersViewModeling: ObservableObject {
    var orders: [Pedido] { get set }
    var ordersAndClient: [PedidoComCliente] { get set }
    var empresa: Empresa? { get set }
    var item: ItemPedido? { get set }
    
    var viewState: ViewState { get }
    
    func fetchPipeline() async
    
    @MainActor
    func goToDetails(order: Pedido)
    
    @MainActor
    func goToValidate(order: Pedido, user: User)
}

class RepresentativeOrdersViewModel: RepresentativeMyOrdersViewModeling {
    @Published var orders: [Pedido] = []
    @Published var ordersAndClient: [PedidoComCliente] = []
    @Published var viewState: ViewState = .new
    @Published var empresa: Empresa?
    @Published var item: ItemPedido?
    @Published var usuario: Usuario?
    
    private weak var coordinator: RepresentativeOrdersNavigation?
    private var orderService = OrderService.shared
    
    init(coordinator: RepresentativeOrdersNavigation?) {
        self.coordinator = coordinator
    }
    
    // Ação de navegação
    @MainActor
    func goToDetails(order: Pedido) {
       // coordinator?.goToDetails(order: order)
    }
    
    @MainActor
    func goToValidate(order: Pedido, user: User) {
        coordinator?.goToValidate(order: order, user: user)
    }
    
    
    func fetchPipeline() async {
        // UX: Mostra loading apenas se a lista estiver vazia para não piscar a tela
        if self.ordersAndClient.isEmpty {
            await MainActor.run { viewState = .loading }
        }
        
        do {
            try await fetchOrders()
            
            await MainActor.run {
                self.viewState = .loaded
            }
        } catch {
            await MainActor.run {
                self.viewState = .error
            }
        }
    }
    
    private func fetchOrders() async throws {
        let email: String = await OrderFlowCache.shared.value(forKey: .email) as? String ?? ""
        
        let orders = try await orderService.getAllRepOrders(repEmail: email)
        await MainActor.run {
            self.orders = orders.map { $0.pedido }
            self.ordersAndClient = orders
        }
    }
    
    /*private func fetchOrdersMock() async throws {
        let pedidoMock = Pedido(id: UUID(), empresaClienteId: UUID(), usuarioCriadorId: UUID(), representanteId: UUID(), status: .alteracao, dataEntregaSolicitada: Date(), dataVencimentoPagamento: Date(), statusRecebimento: .conforme, observacoesCliente: "sei la", dataCriacao: Date(), produtos: [], taxaEntrega: 1)
        let pedidoMock2 = Pedido(id: UUID(), empresaClienteId: UUID(), usuarioCriadorId: UUID(), representanteId: UUID(), status: .cancelamento, dataEntregaSolicitada: Date(), dataVencimentoPagamento: Date(), statusRecebimento: .conforme, observacoesCliente: "sei la2", dataCriacao: Date(),produtos: [], taxaEntrega: 1)
        let pedidoMock3 = Pedido(id: UUID(), empresaClienteId: UUID(), usuarioCriadorId: UUID(), representanteId: UUID(), status: .enviado, dataEntregaSolicitada: Date(), dataVencimentoPagamento: Date(), statusRecebimento: .conforme, observacoesCliente: "sei la3", dataCriacao: Date(), produtos: [], taxaEntrega: 1)
        
        // MOCK 4: Pedido com status 'criado'
        let pedidoMock4 = Pedido(id: UUID(), empresaClienteId: UUID(), usuarioCriadorId: UUID(), representanteId: UUID(),
                                 status: .criado,
                                 dataEntregaSolicitada: Date(), dataVencimentoPagamento: Date(),
                                 statusRecebimento: nil,
                                 observacoesCliente: "sei la4", dataCriacao: Date(), produtos: [], taxaEntrega: 1)
        
        await MainActor.run {
            self.orders = [pedidoMock, pedidoMock2, pedidoMock3, pedidoMock4]
            self.item = ItemPedido(pedidoId: UUID(), produtoId: UUID(), quantidade: 2, precoUnitarioMomento: 10.50)
        }
    }
    
    private func fetchCompany() async throws {
        let mockEmpresa = Empresa(id: UUID(), razaoSocial: "Empresa Teste", nomeFantasia: "Nome Fantasia", cnpj: "123.1323/321", tipo: .clienteFinal, distribuidoraPaiId: UUID())
        
        await MainActor.run {
            self.empresa = mockEmpresa
        }
    }
    
    private func fetchUsuario() async throws {
        let mockUsuario = Usuario(id: UUID(), nomeCompleto: "Nome completo", senha_hash: "Senha", email: "email.com", papel: .adminCliente, empresaId: UUID(), dataCriacao: Date())
        
        await MainActor.run {
            self.usuario = mockUsuario
        }
    }*/
}

