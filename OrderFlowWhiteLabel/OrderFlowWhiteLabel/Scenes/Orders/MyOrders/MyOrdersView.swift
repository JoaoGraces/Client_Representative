//
//  MyOrdersView.swift
//  Trabalho
//
//  Created by Scarllet Gomes on 05/11/25.
//

import SwiftUI

struct MyOrdersView<ViewModel: MyOrdersViewModeling>: View {
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
            .onAppear {
                Task{
                    await viewModel.fetchPipeline()
                }
            }
        case .error:
            GenericErrorView()
        }
    }
}

#Preview {
    ClientCoordinatorView()
}
