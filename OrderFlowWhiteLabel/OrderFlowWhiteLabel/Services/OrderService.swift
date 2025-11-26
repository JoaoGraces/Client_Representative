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

    func createOrder(forUserEmail email: String, pedido: Pedido) async throws {
        let pedidosRef = db.collection("users").document(email).collection("pedidos")
        try pedidosRef.document(pedido.id.uuidString).setData(from: pedido)
    }

    func fetchClientOrders(forUserEmail email: String) async throws -> [Pedido] {
        let snapshot = try await db
            .collection("users")
            .document(email)
            .collection("pedidos")
            .order(by: "dataCriacao", descending: true)
            .getDocuments()

        return snapshot.documents.compactMap { try? $0.data(as: Pedido.self) }
    }

    func fetchAllOrders() async throws -> [Pedido] {
        let usersSnapshot = try await db.collection("users").getDocuments()
        var allPedidos: [Pedido] = []

        for userDoc in usersSnapshot.documents {
            let pedidosSnapshot = try await userDoc.reference.collection("pedidos").getDocuments()
            let pedidos = pedidosSnapshot.documents.compactMap { try? $0.data(as: Pedido.self) }
            allPedidos.append(contentsOf: pedidos)
        }

        return allPedidos
    }

    func updateOrder(forUserEmail email: String, pedido: Pedido) async throws {
        let docRef = db.collection("users").document(email)
            .collection("pedidos")
            .document(pedido.id.uuidString)
        try  docRef.setData(from: pedido, merge: true)
    }

    func deleteOrder(forUserEmail email: String, pedidoId: UUID) async throws {
        let docRef = db.collection("users").document(email)
            .collection("pedidos")
            .document(pedidoId.uuidString)
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

            do {
                try await OrderService.shared.createOrder(
                    forUserEmail: "brunoamteodoro@gmail.com",
                    pedido: pedido
                )
                print("✅ Pedido created successfully!")
            } catch {
                print("❌ Error creating pedido:", error)
            }
        }
}
