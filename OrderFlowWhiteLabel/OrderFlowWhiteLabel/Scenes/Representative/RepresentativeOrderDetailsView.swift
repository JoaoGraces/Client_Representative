//
//  SentView.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Ribeiro Noronha on 06/11/25.
//
import SwiftUI

struct RepresentativeOrderDetailsView<ViewModel: RepresentativeOrderDetailsViewModeling>: View {
    @State private var viewModel: ViewModel
     
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
     
    var body: some View {
        switch viewModel.viewState {
        case .error:
    
            EmptyView()
            
        case .loaded:
            if let empresa = viewModel.empresa, let usuario = viewModel.usuario {
                ScrollView {
                    VStack(spacing: DS.Spacing.pageLeading){
                        DSCard2 {
                            VStack(alignment: .leading, spacing: DS.Spacing.insetX) {
                                
                                HStack {
                                    // CORRIGIDO: O '$' foi removido
                                    // e 'id' (sendo UUID) é formatado
                                    Text("Pedido #\(viewModel.order.id.uuidString.prefix(8))")
                                        .font(DS.Typography.sectionTitle())
                                    
                                    Spacer()
                                    
                                    StatusBadge(status: viewModel.order.status)
                                }
                                .padding(.horizontal, DS.Spacing.insetX)
                                
                                DSFullInsetDivider()
                                
                                OrderSection(title: "Itens do Pedido", content: {
                                    VStack(spacing: DS.Spacing.insetX) {
                                        
                    
                                        ForEach(Array(zip(viewModel.itens, viewModel.produtos)), id: \.0.id) { (item, produto) in
                                            MyOrderItemRow(item: item, produto: produto)
                                        }
                                    }
                                })
                                
                                OrderSection(title: "Endereço de Entrega") {
                                    Text("\(empresa.nomeFantasia)")
                                        .font(.system(.subheadline))
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal)
                                }
                                
                                OrderSection(title: "Informações do Cliente") {
                                    Text(usuario.nomeCompleto)
                                        .font(.system(.subheadline))
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal)
                                }
                                
                                HStack {
                                    DSSectionHeader(title: "Total do Pedido")
                                    Spacer()
                                    DSHilightValue(title: "R$ \(viewModel.calculateTotal().formattedMoney)")
                                }
                            }
                            .padding(.vertical)
                        }
                        
        
                    }
                    .navigationTitle("Detalhes do Pedido")
                    .navigationBarTitleDisplayMode(.inline)
                }
                 
            } else {
                // Caso 'loaded' mas 'empresa' ou 'usuario' sejam nulos
                Text("Erro ao carregar detalhes (empresa ou usuário nulo).")
            }
            
        case .loading, .new:
            ProgressView()
                .onAppear {
                    Task{
                        await viewModel.fetchPipeline()
                    }
                }
        }
    }
}

private class PreviewDetailsCoordinator: RepresentativeOrderDetailsNavigation {
    func requestUpdate(order: Pedido) {
        print("Preview: Pediu para Atualizar")
    }
    
    func requestCancel(order: Pedido) {
        print("Preview: Pediu para Cancelar")
    }
}

#Preview("Preview Tela de Detalhes") {
    
    let mockPedido = Pedido(
        id: UUID(),
        empresaClienteId: UUID(),
        usuarioCriadorId: UUID(),
        representanteId: UUID(),
        status: .enviado, // O status inicial
        dataEntregaSolicitada: Date(),
        dataVencimentoPagamento: Date(),
        statusRecebimento: .conforme,
        observacoesCliente: "Pedido Mock para Preview",
        dataCriacao: Date()
    )
    
    // Criamos o seu ViewModel real (o novo)
    let viewModel = RepresentativeOrderDetailsViewModel(
        coordinator: PreviewDetailsCoordinator(), // Agora usa a classe que está "fora"
        pedido: mockPedido
    )
    
    // Retornamos a View
    NavigationView {
        RepresentativeOrderDetailsView(viewModel: viewModel)
    }
}
