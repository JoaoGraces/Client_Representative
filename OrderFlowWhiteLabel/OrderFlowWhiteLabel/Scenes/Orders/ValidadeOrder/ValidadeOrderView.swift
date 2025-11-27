//
//  MyOrdersView.swift
//  Trabalho
//
//  Created by Scarllet Gomes on 05/11/25.
//

import SwiftUI

struct ValidadeOrderView<ViewModel: ValidadeOrderViewModeling>: View {
    @ObservedObject private var viewModel: ViewModel
    
    @State private var showRejectConfirmation = false
    
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
                            DSSectionHeader(title: "Pedido #\(viewModel.order.id.uuidString.suffix(6))")
                            
                            HStack{
                                Text("Data:")
                                    .font(DS.Typography.body())
                                
                                Spacer()
                                
                                Text(DateFormatter.ptLong.string(from: viewModel.order.dataCriacao))
                                    .font(DS.Typography.body())
                            }
                            
                            HStack{
                                Text("Cliente:")
                                    .font(DS.Typography.body())
                                
                                Spacer()
                                
                                Text(viewModel.usuario.name)
                                    .font(DS.Typography.bodySemibold())
                            }
                            
                            HStack{
                                Text("Endereço de entrega:")
                                    .font(DS.Typography.body())
                                
                                Spacer()
                                
                                Text(viewModel.usuario.address)
                                    .font(DS.Typography.bodySemibold())
                            }
                            
                            HStack{
                                Text("Status:")
                                    .font(DS.Typography.body())
                                
                                Spacer()
                                
                                StatusBadge(status: viewModel.order.status)
                            }
                            
                            DSFullInsetDivider()
                            
                            HStack{
                                Text("Frete:")
                                    .font(DS.Typography.body())
                                
                                Spacer()
                                
                                Text("R$ \(viewModel.order.taxaEntrega.twoDecimals)")
                                    .font(DS.Typography.bodySemibold())
                            }
                            .padding(.top)
                            
                            HStack{
                                Text("Valor Total:")
                                    .font(DS.Typography.body())
                                
                                Spacer()
                                
                                Text("R$ \(viewModel.order.total.twoDecimals)")
                                    .font(DS.Typography.bodySemibold())
                            }
                            .padding(.bottom)
                            
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
                                        
                                        Text("\(item.quantidade)x \(item.precoUnitarioMomento.twoDecimals)")
                                            .font(DS.Typography.body())
                                    }
                                    
                                    Spacer()
                                    
                                    Text("R$ \(item.valorTotal.twoDecimals)")
                                        .font(DS.Typography.bodySemibold())
                                }
                                
                            }
                        }
                        .padding()
                    }
                    
                    DSFullInsetDivider()
                    
                    
                    if viewModel.order.status != .aprovado {
                        PrimaryButton(title: "Aprovar Pedido") {
                            viewModel.aproveOrder()
                        }
                    }
                    if viewModel.order.status != .rejeitado {
                        SecondaryButton(title: "Rejeitar Pedido") {
                            showRejectConfirmation = true
                        }
                        .alert("Confirmar Rejeição", isPresented: $showRejectConfirmation) {
                            Button("Cancelar", role: .cancel) { }
                            
                            Button("Rejeitar", role: .destructive) {
                                viewModel.rejectOrder()
                            }
                        } message: {
                            Text("Tem certeza que deseja rejeitar este pedido? Esta ação não pode ser desfeita.")
                        }
                    }
                }
            }
            .navigationTitle("Validar Pedido")
            .navigationBarTitleDisplayMode(.inline)
        case .error:
            GenericErrorView()
        }
    }
}

#Preview {
    ClientCoordinatorView()
}
