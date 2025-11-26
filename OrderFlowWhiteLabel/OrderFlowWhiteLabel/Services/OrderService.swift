//
//  OrderService.swift
//  OrderFlowWhiteLabel
//
//  Created by Bruno Teodoro on 22/11/25.
//

import Foundation
import FirebaseFirestore

final class OrderService {
    static let shared = OrderService()
    private let db = Firestore.firestore()
    private init() {}

    func createOrder(forUserEmail email: String, order: OrderConfirmation) async throws {
        let pedidosRef = db.collection("users").document(email).collection("pedidos")
        try pedidosRef.document(order.pedido.id.uuidString).setData(from: order)
    }

    func fetchClientOrders(forUserEmail email: String) async throws -> [OrderConfirmation] {
        let snapshot = try await db
            .collection("users")
            .document(email)
            .collection("pedidos")
            .order(by: "pedido.dataCriacao", descending: true)
            .getDocuments()

        return snapshot.documents.compactMap { try? $0.data(as: OrderConfirmation.self) }
    }

    func fetchAllOrders() async throws -> [OrderConfirmation] {
        let usersSnapshot = try await db.collection("users").getDocuments()
        var allPedidos: [OrderConfirmation] = []

        for userDoc in usersSnapshot.documents {
            let pedidosSnapshot = try await userDoc.reference.collection("pedidos").getDocuments()
            let pedidos = pedidosSnapshot.documents.compactMap { try? $0.data(as: OrderConfirmation.self) }
            allPedidos.append(contentsOf: pedidos)
        }

        return allPedidos
    }

    func updateOrder(forUserEmail email: String, order: OrderConfirmation) async throws {
        let docRef = db.collection("users").document(email)
            .collection("pedidos")
            .document(order.pedido.id.uuidString)
        try  docRef.setData(from: order, merge: true)
    }

    func deleteOrder(forUserEmail email: String, orderId: UUID) async throws {
        let docRef = db.collection("users").document(email)
            .collection("pedidos")
            .document(orderId.uuidString)
        try await docRef.delete()
    }
    
    func testCreateOrder() async {
            let pedido = Pedido(
                id: UUID(),
                empresaClienteId: UUID(),
                usuarioCriadorId: UUID(),
                representanteId: UUID(),
                status: .criado,
                dataEntregaSolicitada: Date().addingTimeInterval(86400 * 5),
                dataVencimentoPagamento: Date().addingTimeInterval(86400 * 30),
                statusRecebimento: nil,
                observacoesCliente: "Entrega rápida, por favor",
                dataCriacao: Date()
            )
        
        let order = OrderConfirmation(pedido: pedido, itens: [], taxaEntrega: 1)

            do {
                try await OrderService.shared.createOrder(
                    forUserEmail: "brunoamteodoro@gmail.com",
                    order: order
                )
                print("✅ Pedido created successfully!")
            } catch {
                print("❌ Error creating pedido:", error)
            }
        }
}
