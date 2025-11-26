//
//  OrderDetails.swift
//  Trabalho
//
//  Created by Scarllet Gomes on 05/11/25.
//

import SwiftUI

struct OrderDetails<ViewModel: OrderDetailsViewModeling>: View {
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
                                    Text("Pedido #\($viewModel.order.id)")
                                        .font(DS.Typography.sectionTitle())
                                    
                                    Spacer()
                                    
                                    StatusBadge(status: viewModel.order.status)
                                }
                                .padding(.horizontal, DS.Spacing.insetX)
                                
                                DSFullInsetDivider()
                                
                                OrderSection(title: "Itens do Pedido", content: {
                                    VStack(spacing: DS.Spacing.insetX) {
                                        ForEach(viewModel.itens, id: \.id) { item in
                                            MyOrderItemRow(item: item, produto: viewModel.produtos[0])
                                        }
                                    }
                                })
                                
                                OrderSection(title: "Endereço de Entrega") {
                                    //TODO: não tem endereço nem de empresa nem de Usuario
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
                                    
                                    DSHilightValue(title: "R$ \(viewModel.calculateTotal())")
                                }
                            }
                            .padding(.vertical)
                        }
                        
                        PrimaryButton(title: "Solicitar Alteração") {
                            //TODO: Concluir Ação
                        }
                        
                        DangerButton(title: "Solicitar Cancelamento") {
                            //TODO: Concluir Ação
                        }
                    }
                    .navigationTitle("Detalhes do Pedido")
                    .navigationBarTitleDisplayMode(.inline)
                }
                
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
