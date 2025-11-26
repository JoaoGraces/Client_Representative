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
    func getClientsForRepresentative(repId: String) async throws -> [User] {
        /* Lógica futura:
         let snapshot = try await db.collection("user")
         .whereField("representativeId", isEqualTo: repId)
         .getDocuments()
         
         return snapshot.documents.compactMap { try? $0.data(as: User.self) }
         */
        return [] // Retorno vazio temporário para não quebrar a build se não tiver User
    }
}

/***    func getUserRole(email: String) async throws -> UserRole {
 let doc = try await db.collection("users").document(email).getDocument()
 guard let data = doc.data(),
 let roleString = data["role"] as? String,
 let role = UserRole(rawValue: roleString) else {
 throw NSError(domain: "FirestoreError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Role inválida ou documento inexistente"])
 }
 return role
 }
 }
 ***/

