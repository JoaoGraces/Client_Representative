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
            GenericErrorView()
        case .loaded:
            ScrollView {
                VStack(spacing: DS.Spacing.pageLeading){
                    DSCard2 {
                        VStack(alignment: .leading, spacing: DS.Spacing.insetX) {
                            
                            HStack {
                                Text("Pedido #\(viewModel.order.id.uuidString.suffix(6))")
                                    .font(DS.Typography.sectionTitle())
                                
                                Spacer()
                                
                                StatusBadge(status: viewModel.order.status)
                            }
                            .padding(.horizontal, DS.Spacing.insetX)
                            
                            DSFullInsetDivider()
                            
                            OrderSection(title: "Itens do Pedido", content: {
                                VStack(spacing: DS.Spacing.insetX) {
                                    ForEach(viewModel.itens.indices, id: \.self) { index in
                                        MyOrderItemRow(
                                            item: viewModel.itens[index],
                                            produto: viewModel.produtos[index]
                                        )
                                    }
                                }
                            })
                            
                            OrderSection(title: "Endereço de Entrega") {
                                Text(viewModel.usuario.address)
                                    .font(.system(.subheadline))
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal)
                            }
                            
                            OrderSection(title: "Informações do Cliente") {
                                Text(viewModel.usuario.name)
                                    .font(.system(.subheadline))
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal)
                            }
                            
                            OrderSection(title: "Frete") {
                                Text("R$ \(viewModel.order.taxaEntrega.twoDecimals)")
                                    .font(.system(.subheadline))
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal)
                            }
                            
                            HStack {
                                DSSectionHeader(title: "Total do Pedido")
                                
                                Spacer()
                                
                                DSHilightValue(title: "R$ \(viewModel.order.total.twoDecimals)")
                            }
                            .padding(.vertical)
                        }
                        .padding(.vertical)
                        switch viewModel.order.status {
                        case .rejeitado, .finalizado, .cancelamento :
                            EmptyView()
                            
                        case .enviado:
                            PrimaryButton(title: "Confirmar Entrega") {
                                viewModel.confirmShipping()
                            }
                        case .cancelamentoSolicitado:
                            Text("Pedido de cancelamento em análise.")
                                .foregroundColor(.secondary)
                                .padding(.vertical)
                        default:
                            DangerButton(title: "Solicitar Cancelamento") {
                                viewModel.cancelOrder()
                            }
                        }
                    }
                }
                .navigationTitle("Detalhes do Pedido")
                .navigationBarTitleDisplayMode(.inline)
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
