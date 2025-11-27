//
//  CatalogListViewModel.swift
//  OrderFlowWhiteLabel
//
//  Created by João Victor Bernardes Gracês on 03/11/25.
//

import SwiftUI
import Combine

final class ProductListViewModel: ObservableObject {
    @Published private(set) var products: [Produto] = []
    @Published private(set) var allProducts: [Produto] = []
    @Published private(set) var isLoadingMore = false

    @Published var searchText: String = ""
    @Published var viewState: ViewState = .new
    
    @Published var cartItems: [CartItemModel] = []

    private let pageSize = 12
    private var currentPage = 1
    private var cancellables = Set<AnyCancellable>()
    private let orderService = OrderService.shared
    private let apiProvider: APIProvider

    init(apiProvider: APIProvider = APIProvider()) {
        self.apiProvider = apiProvider
        setupSearch()
    }

    // MARK: Pipeline
    func fetchPipeline() async {
        if allProducts.isEmpty {
            await MainActor.run { viewState = .loading }
            do {
                try await loadProducts()
            } catch {
                await MainActor.run { viewState = .error }
            }
        }
    }


    // MARK: Loading base data
    private func loadProducts() async throws {
        // simulação opcional — pode remover se já estiver com backend real
        // try await Task.sleep(nanoseconds: 800_000_000)

        let initial = await fetchProducts()  

        if initial.isEmpty {
            await MainActor.run { viewState = .error }
            return
        }

        await MainActor.run {
            self.allProducts = initial
            self.products = initial
            self.viewState = .loaded
        }
    }

    
    func fetchProducts() async -> [Produto] {
        do {
            let dataProducts: DataProduto = try await apiProvider.request(
                endpoint: "/orderFlow/catalog/products",
                method: .get,
                body: EmptyRequest(),
                responseType: DataProduto.self
            )
            
            return dataProducts.dados
            
        } catch let error as OrderFlowError {
            await MainActor.run { viewState = .error }
        } catch {
            await MainActor.run {  viewState = .error }
        }
        
        return []
    }
    
    // MARK: Search
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
            products = allProducts.filter {
                $0.nome.localizedCaseInsensitiveContains(text)
            }
        }
    }

    // MARK: Pagination
    func loadNextPageIfNeeded(currentProduct: Produto) {
        guard !isLoadingMore else { return }

        let thresholdIndex = products.index(products.endIndex, offsetBy: -2)

        if products.firstIndex(where: { $0.id == currentProduct.id }) == thresholdIndex {
            loadMore()
        }
    }

    private func loadMore() {
        isLoadingMore = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let new = self.mockData()
            self.allProducts.append(contentsOf: new)
            self.filterProducts(by: self.searchText)
            self.isLoadingMore = false
        }
    }
    
    func mockData(prefix: String = "") -> [Produto] {
        let produtos: [Produto] = {
            let itens: [(nome: String, imagem: String)] = [
                // Panelas
                ("Panela Antiaderente 16cm", "https://cdn.awsli.com.br/600x450/1250/1250980/produto/48170735/panela-antiaderente-especial-16-cm-eirilar-17df8d40.jpg"),
                ("Panela de Pressão 4,5L", "https://cdn.awsli.com.br/600x450/1250/1250980/produto/48170740/panela-de-pressao-4-5l.jpg"),
                ("Panela Elétrica Digital", "https://images.unsplash.com/photo-1613470202236-1b8d20eacaf0"),
                
                // Tênis
                ("Tênis All Star Azul", "https://blog.meninashoes.com.br/wp-content/uploads/2024/02/tenis-all-star-azul.jpg"),
                ("Tênis Nike Air Force 1", "https://static.netshoes.com.br/produtos/tenis-nike-air-force-1/26/HZM-2943-026/HZM-2943-026_zoom1.jpg"),
                ("Tênis de Corrida Esportivo", "https://images.unsplash.com/photo-1606813902912-4385f05a56ab"),
                
                // Eletrônicos
                ("Fone de Ouvido Bluetooth", "https://images.unsplash.com/photo-1580910051073-3b1b3c6b19f3"),
                ("Smartphone 128GB", "https://images.unsplash.com/photo-1580894908361-967195033215"),
                ("Caixa de Som Portátil", "https://images.unsplash.com/photo-1590845947376-7c55dedb17a6"),
                
                // Livros
                ("Livro: A Arte da Guerra", "https://images.unsplash.com/photo-1512820790803-83ca734da794"),
                ("Livro: O Pequeno Príncipe", "https://images.unsplash.com/photo-1524995997946-a1c2e315a42f"),
                ("Livro: 1984 - George Orwell", "https://images.unsplash.com/photo-1589829085413-56de8ae18c73")
            ]
            
            return itens.map { item in
                Produto(
                    id: UUID(),
                    distribuidoraId: UUID(),
                    nome: item.nome,
                    quantidade: 0,
                    precoUnidade: Double.random(in: 20...800),
                    estoque: Int.random(in: 0...50),
                    imageName: item.imagem,
                    tagText: ["Promoção", "Novo", "Destaque"].randomElement()!
                )
            }
        }()
        return produtos
    }
}

extension ProductListViewModel {
    func addToCart(_ product: Produto, quantity: Int = 1) {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[index].quantity += quantity
            cartItems[index].product.quantidade += quantity
        } else {
            var newItem = CartItemModel(product: product, quantity: quantity)
            newItem.product.quantidade += 1
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
        cartItems.reduce(0) { $0 + (Double($1.product.precoUnidade) * Double($1.quantity)) }
    }
    
    func increaseQuantity(for product: Produto) {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[index].quantity += 1
            cartItems[index].product.quantidade += 1
        }
    }
    
    func decreaseQuantity(for product: Produto) {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            if cartItems[index].quantity > 1 {
                cartItems[index].quantity -= 1
                cartItems[index].product.quantidade -= 1
            } else {
                removeFromCart(cartItems[index])
            }
            
        }
    }
    
    func clearCart() {
        cartItems.removeAll()
    }
    
    func createOrderConfirmation(with order: Pedido) {
        Task {
            let email: String = await OrderFlowCache.shared.value(forKey: .email) as? String ?? ""
            do {
                try await orderService.createOrder(forUserEmail: email, order: order)
            } catch {
                print("Erro ao criar pedido: \(error)")
            }
        }
    }
}
