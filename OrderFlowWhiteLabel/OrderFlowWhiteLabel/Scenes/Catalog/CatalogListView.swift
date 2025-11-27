//
//  CatalogListView.swift
//  OrderFlowWhiteLabel
//
//  Created by João Victor Bernardes Gracês on 03/11/25.
//

import SwiftUI

struct CatalogListView: View {
    @ObservedObject var viewModel: ProductListViewModel
    
    private let gridColumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        Group {
            switch viewModel.viewState {
            case .new, .loading:
                ProgressView()
                
            case .loaded:
                NavigationStack {
                    ScrollView {
                        LazyVGrid(columns: gridColumns, spacing: 16) {
                            ForEach(viewModel.products) { product in
                                ProductItemView(
                                    imageURL: product.imageName,
                                    name: product.nome,
                                    price: product.formattedPrice,
                                    tagText: product.tagText
                                ) {
                                    viewModel.addToCart(product)
                                }
                                .onAppear {
                                    viewModel.loadNextPageIfNeeded(currentProduct: product)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        
                        if viewModel.isLoadingMore {
                            ProgressView()
                                .padding()
                        }
                    }
                    .navigationTitle("Catálogo de Produtos")
                    .navigationBarTitleDisplayMode(.inline)
                    .searchable(
                        text: $viewModel.searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Buscar produtos..."
                    )
                }


            case .error:
                GenericErrorView {
                    Task { await viewModel.fetchPipeline() }
                }
            }
        }
        .onAppear {
            Task { await viewModel.fetchPipeline() }
        }
    }
}

#Preview {
    CatalogListView(viewModel: ProductListViewModel())
}
