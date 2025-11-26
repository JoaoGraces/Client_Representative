//
//  RepresentativeOrdersView.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Ribeiro Noronha on 06/11/25.
//

import SwiftUI

struct RepresentativeOrdersView<ViewModel: MyOrdersViewModeling>: View {
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
                    ForEach(viewModel.orders, id: \.id) { order in
                        DSCard2 {
                            if let empresa = viewModel.empresa,  let item = viewModel.item {
                                OrderCell(order: order, empresa: empresa, item: item, action: {
                                    
                                    viewModel.goToValidate(order: order)
                                    
                                })
                                .padding(DS.Spacing.insetX)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Pedidos")
            .navigationBarTitleDisplayMode(.inline)
        case .error:
            EmptyView()
        }
    }
}


#Preview {
    RepresentativeCoordinatorView()
}
