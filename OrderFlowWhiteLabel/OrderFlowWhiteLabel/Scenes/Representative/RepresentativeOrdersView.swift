//
//  RepresentativeOrdersView.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Ribeiro Noronha on 06/11/25.
//

import SwiftUI

struct RepresentativeOrdersView<ViewModel: RepresentativeMyOrdersViewModeling>: View {
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
                    VStack (spacing: DS.Spacing.insetX){
                        ForEach(viewModel.ordersAndClient, id: \.pedido.id) { item in
                            DSCard2 {
                                OrderCell(order: item.pedido, action: {
                                    viewModel.goToValidate(order: item.pedido, user: item.usuario)
                                })
                                .padding(DS.Spacing.insetX)
                            }
                        }
                    }
                }
                .navigationTitle("Pedidos")
                .navigationBarTitleDisplayMode(.inline)
            case .error:
                GenericErrorView {
                    Task { await viewModel.fetchPipeline() }
                }
            }
        }
        .onAppear{
            Task{
                await viewModel.fetchPipeline()
            }
        }
    }
}


#Preview {
    RepresentativeCoordinatorView(onLogout: {
        print("Logout simulado no Preview")
    })
}
