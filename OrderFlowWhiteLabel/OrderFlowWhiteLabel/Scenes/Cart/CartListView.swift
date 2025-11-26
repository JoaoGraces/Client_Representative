//
//  CartListView.swift
//  OrderFlowWhiteLabel
//
//  Created by João Victor Bernardes Gracês on 06/11/25.
//

import SwiftUI

struct CartListView: View {
    enum Constants {
        static let navigationTitle = "Novo Pedido"
        
        // Empty Cart
        static let emptyCartSpacing: CGFloat = 12
        static let emptyCartIcon = "cart"
        static let emptyCartIconSize: CGFloat = 56
        static let emptyCartText = "Seu carrinho está vazio"
        
        // Remove Button
        static let removeButtonLabel = "Remover"
        static let removeButtonIcon = "trash"
        
        // Total Section
        static let totalLabel = "Total:"
        static let totalFormat = "%.2f"
        static let totalShadowRadius: CGFloat = 2
    }
    @ObservedObject var viewModel: ProductListViewModel
    @ObservedObject var coordinator: CartCoordinator
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.cartItems.isEmpty {
                    emptyCartView
                } else {
                    cartListView
                    totalSection
                    PrimaryButton(title: "Conferir Pedido", action: {
                        coordinator.go(to: .checkout(products: viewModel.cartItems))
                    })
                }
            }
            .navigationTitle(Constants.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Subviews
private extension CartListView {
    var emptyCartView: some View {
        VStack(spacing: Constants.emptyCartSpacing) {
            Image(systemName: Constants.emptyCartIcon)
                .font(.system(size: Constants.emptyCartIconSize))
                .foregroundColor(DS.Colors.neutral700)
            
            Text(Constants.emptyCartText)
                .font(DS.Typography.body2())
                .foregroundColor(DS.Colors.neutral700)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var cartListView: some View {
        List {
            ForEach($viewModel.cartItems) { $item in
                ProductCartItemView(
                    title: item.product.nome,
                    imageURL: item.product.imageName,
                    unitPrice: item.product.precoUnidade,
                    quantity: $item.quantity,
                    onIncrease: { viewModel.increaseQuantity(for: item.product) },
                    onDecrease: { viewModel.decreaseQuantity(for: item.product) }
                )
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        viewModel.removeFromCart(item)
                    } label: {
                        Label(Constants.removeButtonLabel, systemImage: Constants.removeButtonIcon)
                    }
                }
                // garante que a área do row receba toques corretamente
                .contentShape(Rectangle())
            }
        }
        .listStyle(.plain)
    }
    
    var totalSection: some View {
        HStack {
            Text(Constants.totalLabel)
                .font(DS.Typography.body2())
                .foregroundColor(DS.Colors.neutral900)
            
            Spacer()
            
            Text("R$ \(viewModel.totalCartValue, specifier: Constants.totalFormat)")
                .font(DS.Typography.title3())
                .foregroundColor(DS.Colors.blueBase)
        }
        .padding()
        .background(DS.Colors.white.shadow(radius: Constants.totalShadowRadius))
    }
}

#Preview {
    CartListView(viewModel: ProductListViewModel(), coordinator: CartCoordinator())
}
