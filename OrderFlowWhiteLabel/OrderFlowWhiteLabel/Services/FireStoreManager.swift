//
//  FireStoreManager.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Eduardo on 04/11/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

enum UserRole: String {
    case pending
    case client
    case representative
}

final class FirestoreManager {
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func createUserDocument(email: String, name: String, phone: String, address: String, representativeEmail: String) async throws {
        let docRef = db.collection("users").document(email)
        
        let data: [String: Any] = [
            "email": email,
            "name": name,
            "phone": phone,
            "address": address,
            "role": "pending",
            "representative_id": representativeEmail,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        try await docRef.setData(data)
    }
    func getAllRepresentatives() async throws -> [Representative] {
        let snapshot = try await db.collection("representative").getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Representative.self) }
    }
    
    func getUserRole(email: String) async throws -> UserRole {
        
        let repDoc = try await db.collection("representative").document(email).getDocument()
        if repDoc.exists {
            return .representative
        }
        
        let userDoc = try await db.collection("users").document(email).getDocument()
        
        if userDoc.exists {
            if let data = userDoc.data(),
               let roleString = data["role"] as? String,
               let role = UserRole(rawValue: roleString) {
                return role
            }
            return .client
        }
        
        throw NSError(domain: "FirestoreError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Usuário não encontrado em nenhuma coleção"])
    }
    
    func getClientsForRepresentative(repEmail: String) async throws -> [User] {
        
        let snapshot = try await db.collection("users")
            .whereField("representative_id", isEqualTo: repEmail)
            .getDocuments()
        
        let clients = snapshot.documents.compactMap { document -> User? in
            try? document.data(as: User.self)
        }
        
        return clients
    }
}
