//
//  CatalogListViewModel.swift
//  OrderFlowWhiteLabel
//
//  Created by João Victor Bernardes Gracês on 03/11/25.
//

import SwiftUI
import Combine

import SwiftUI
import Combine

final class ProductListViewModel: ObservableObject {
    @Published private(set) var products: [ProductModel] = []
    @Published private(set) var isLoadingMore = false
    @Published var searchText: String = ""
    @Published var cartItems: [CartItemModel] = []
    
    private var currentPage = 1
    private let pageSize = 10
    private var allProducts: [ProductModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadProducts()
        setupSearch()
    }
    
    private func setupSearch() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.filterProducts(by: text)
            }
            .store(in: &cancellables)
    }
    
    private func filterProducts(by text: String) {
        if text.isEmpty {
            products = allProducts
        } else {
            products = allProducts.filter { $0.name.localizedCaseInsensitiveContains(text) }
        }
    }
    
    func loadProducts() {
        // Simulação inicial (em app real viria de API)
        let newProducts = mockData()
        allProducts.append(contentsOf: newProducts)
        products = allProducts
    }
    
    func loadNextPageIfNeeded(currentProduct: ProductModel) {
        guard !isLoadingMore else { return }
        
        let thresholdIndex = products.index(products.endIndex, offsetBy: -2)
        if products.firstIndex(where: { $0.id == currentProduct.id }) == thresholdIndex {
            loadMore()
        }
    }
    
    private func loadMore() {
        isLoadingMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.currentPage += 1
            let newProducts = self.mockData()
            self.allProducts.append(contentsOf: newProducts)
            self.filterProducts(by: self.searchText)
            self.isLoadingMore = false
        }
    }
    
    func mockData(prefix: String = "") -> [ProductModel] {
        (1...6).map {
            ProductModel(
                id: UUID(),
                distribuidoraId: UUID(),
                name: "\(prefix) Produto \($0) com nome grande para testar quebra de linha",
                description: "Descrição do produto \($0) com detalhes adicionais.",
                price: Float.random(in: 10...1000),
                stock: Int.random(in: 0...50),
                imageName: [
                    "https://cdn.awsli.com.br/600x450/1250/1250980/produto/48170735/panela-antiaderente-especial-16-cm-eirilar-17df8d40.jpg", // panela
                    "https://blog.meninashoes.com.br/wp-content/uploads/2024/02/tenis-all-star-azul.jpg", // tenis
                    "https://images.unsplash.com/photo-1512499617640-c2f999098bba"
                ].randomElement()!,
                tagText: ["Promoção", "Novo", "Destaque"].randomElement()!
            )
        }
    }
}

extension ProductListViewModel {
    func addToCart(_ product: ProductModel, quantity: Int = 1) {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[index].quantity += quantity
        } else {
            let newItem = CartItemModel(product: product, quantity: quantity)
            cartItems.append(newItem)
        }
    }
    
    func removeFromCart(_ item: CartItemModel) {
        cartItems.removeAll { $0.id == item.id }
    }
    
    func updateQuantity(for item: CartItemModel, to newQuantity: Int) {
        guard let index = cartItems.firstIndex(of: item) else { return }
        cartItems[index].quantity = newQuantity
    }
    
    var totalCartValue: Double {
        cartItems.reduce(0) { $0 + (Double($1.product.price) * Double($1.quantity)) }
    }
}
