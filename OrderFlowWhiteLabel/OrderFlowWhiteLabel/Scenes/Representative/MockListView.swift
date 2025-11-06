//
//  MockListView.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Ribeiro Noronha on 06/11/25.
//

import SwiftUI

struct MockListView: View {
    // 1. Recebemos o coordinator para poder navegar
    @ObservedObject var coordinator: RepresentativeCoordinator
    
    var body: some View {
        List {
            // 2. Criamos botões que simulam os itens da lista
            // Cada botão chama o coordinator com a rota correta
            Button("Simular item: CANCELAMENTO") {
                coordinator.go(to: .cancelamento)
            }
            
            Button("Simular item: ENVIADO") {
                coordinator.go(to: .enviado)
            }
            
            Button("Simular item: ALTERAÇÃO") {
                coordinator.go(to: .alteracao)
            }
            
            Button("Simular item: NOVO PEDIDO") {
                coordinator.go(to: .novoPedido)
            }
        }
        .navigationTitle("Lista de Pedidos (Representante)")
    }
}
