//
//  MyOrdersView.swift
//  Trabalho
//
//  Created by Scarllet Gomes on 05/11/25.
//

import SwiftUI

struct ValidadeOrderView<ViewModel: ValidadeOrderViewModeling>: View {
    @State private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        switch viewModel.viewState {
        case .new, .loading:
            ProgressView()
                .onAppear{
                    Task{
                        await viewModel.fetchPipeline()
                    }
                }
        case .loaded:
            ScrollView{
                VStack (spacing: DS.Spacing.insetX){
                    DSCard2 {
                        VStack(alignment: .leading) {
                            DSSectionHeader(title: "Pedido \(viewModel.order.pedido.id)")
                            
                            HStack{
                                Text("Data:")
                                    .font(DS.Typography.body())
                                
                                Spacer()
                                
                                Text(DateFormatter.ptLong.string(from: viewModel.order.pedido.dataCriacao))
                                    .font(DS.Typography.body())
                            }
                            
                            HStack{
                                Text("Cliente:")
                                    .font(DS.Typography.body())
                                
                                Spacer()
                                
                                Text(viewModel.empresa?.nomeFantasia ?? "")
                                    .font(DS.Typography.bodySemibold())
                            }
                            
                            HStack{
                                Text("Endereço de entrega:")
                                    .font(DS.Typography.body())
                                
                                Spacer()
                                
                                Text(viewModel.empresa?.nomeFantasia ?? "")
                                    .font(DS.Typography.bodySemibold())
                            }
                            
                            HStack{
                                Text("Status:")
                                    .font(DS.Typography.body())
                                
                                Spacer()
                                
                                StatusBadge(status: viewModel.order.pedido.status)
                            }
                            
                            DSFullInsetDivider()
                            
                            HStack{
                                Text("Valor Total:")
                                    .font(DS.Typography.body())
                                
                                Spacer()
                                
                                Text("\(viewModel.calculateTotal())")
                                    .font(DS.Typography.bodySemibold())
                            }
                            .padding(.vertical)
                            
                        }
                        .padding()
                        
                    }
                    
                    DSCard2 {
                        DSSectionHeader(title: "Itens do Pedido:")
                            .padding(.top)
                        
                        VStack{
                            ForEach(viewModel.itens, id: \.id) { item in
                                HStack{
                                    VStack{
                                        Text("Produto")
                                            .font(DS.Typography.bodySemibold())
                                        
                                        Text("\(item.quantidade)x \(item.precoUnitarioMomento)")
                                            .font(DS.Typography.body())
                                    }
                                    
                                    Spacer()
                                    
                                    Text("R$ \(item.valorTotal)")
                                        .font(DS.Typography.bodySemibold())
                                }
                                
                            }
                        }
                        .padding()
                    }
                
                    DSFullInsetDivider()
                    
                    PrimaryButton(title: "Aprovar Pedido") {
                        viewModel.aproveOrder()
                    }
                    
                    SecondaryButton(title: "Rejeitar Pedido") {
                        viewModel.rejectOrder()
                    }
                    
                }
            }
            .navigationTitle("Validar Pedido")
            .navigationBarTitleDisplayMode(.inline)
        case .error:
            EmptyView()
        }
    }
}

#Preview {
    ClientCoordinatorView()
}
