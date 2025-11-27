//
//  MyOrdersView.swift
//  Trabalho
//
//  Created by Scarllet Gomes on 05/11/25.
//

import SwiftUI

struct MyOrdersView<ViewModel: MyOrdersViewModeling>: View {
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Group {
            switch viewModel.viewState {
            case .new, .loading:
                ProgressView()
                
            case .loaded:
                ScrollView{
                    if viewModel.orders.isEmpty {
                        Text("Nenhum pedido encontrado")
                            .foregroundColor(.gray)
                            .padding(.top, 50)
                    }
                    VStack (spacing: DS.Spacing.insetX){
                        ForEach(viewModel.orders, id: \.self) { order in
                            DSCard2 {
                                OrderCell(order: order, action: {
                                    viewModel.goToDetails(order: order)
                                })
                                .padding(DS.Spacing.insetX)
                            }
                        }
                    }
                }
                .navigationTitle("Meus Pedidos")
                .navigationBarTitleDisplayMode(.inline)
              
            case .error:
                GenericErrorView {
                    Task { await viewModel.fetchPipeline() }
                }
            }
        }
        .onAppear {
            Task{
                await viewModel.fetchPipeline()
            }
        }
    }
}

#Preview {
    ClientCoordinatorView()
}
