//
//  CartListView.swift
//  OrderFlowWhiteLabel
//
//  Created by João Victor Bernardes Gracês on 06/11/25.
//

import SwiftUI

struct CartListView: View {
    @ObservedObject var viewModel: ProductListViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.cartItems.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "cart")
                            .font(.system(size: 56))
                            .foregroundColor(DS.Colors.neutral600)
                        Text("Seu carrinho está vazio")
                            .font(DS.Typography.body2())
                            .foregroundColor(DS.Colors.neutral600)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.cartItems) { item in
                            ProductCartItemView(
                                title: item.product.name,
                                imageURL: item.product.imageName,
                                unitPrice: Double(item.product.price)
                            )
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    viewModel.removeFromCart(item)
                                } label: {
                                    Label("Remover", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    
                    // Total
                    HStack {
                        Text("Total:")
                            .font(DS.Typography.body2())
                            .foregroundColor(DS.Colors.neutral900)
                        
                        Spacer()
                        
                        Text("R$ \(viewModel.totalCartValue, specifier: "%.2f")")
                            .font(DS.Typography.title3())
                            .foregroundColor(DS.Colors.blueBase)
                    }
                    .padding()
                    .background(DS.Colors.white.shadow(radius: 2))
                }
            }
            .navigationTitle("Novo Pedido")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


#Preview {
    CartListView(viewModel:  ProductListViewModel())
}
