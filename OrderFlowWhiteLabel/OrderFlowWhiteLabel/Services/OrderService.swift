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
    
    func createOrder(forUserEmail email: String, order: Pedido) async throws {
        let pedidosRef = db.collection("users").document(email).collection("pedidos")
        try pedidosRef.document(order.id.uuidString).setData(from: order)
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
    
    func updateOrder(forUserEmail email: String, order: Pedido) async throws {
        let docRef = db.collection("users").document(email)
            .collection("pedidos")
            .document(order.id.uuidString)
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
            dataCriacao: Date(),
            produtos: [],
            taxaEntrega: 10.0
        )
        
        do {
            try await OrderService.shared.createOrder(
                forUserEmail: "brunoamteodoro@gmail.com",
                order: pedido
            )
            print("✅ Pedido created successfully!")
        } catch {
            print("❌ Error creating pedido:", error)
        }
    }
    
    func getAllRepOrders(repEmail: String) async throws -> [PedidoComCliente] {
        var result: [PedidoComCliente] = []
        
        let snapshot = try await db.collection("users")
            .whereField("representative_id", isEqualTo: repEmail)
            .getDocuments(source: .server)
        
        let clients = snapshot.documents.compactMap { document -> User? in
            try? document.data(as: User.self)
        }
        
        for client in clients {
            // Se o Cliente A der erro, o app não trava; ele pula pro Cliente B.
            do {
                let snapshot = try await db
                    .collection("users")
                    .document(client.email)
                    .collection("pedidos")
                    .getDocuments()
                
                let pedidos = snapshot.documents.compactMap { doc -> Pedido? in
                    do {
                        return try doc.data(as: Pedido.self)
                    } catch {
                        print("⚠️ Erro decode pedido \(doc.documentID): \(error)")
                        return nil
                    }
                }
                
                for pedido in pedidos {
                    result.append(PedidoComCliente(pedido: pedido, usuario: client))
                }
            } catch {
                print("❌ Erro ao buscar pedidos do cliente \(client.email): \(error)")
                continue  // Continua o loop sem quebrar a tela
                
            }
        }
        
        return result
    }
    
}
