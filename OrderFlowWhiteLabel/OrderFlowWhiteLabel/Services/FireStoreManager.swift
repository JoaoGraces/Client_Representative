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
    
    func createUserDocument(email: String, representative: String) async throws {
        let docRef = db.collection("users").document(email)
        try await docRef.setData([
            "email": email,
            "role": "pending",
            "representative": representative,
            "createdAt": FieldValue.serverTimestamp()
        ])
    }
    
    func getUserRole(email: String) async throws -> UserRole {
        let doc = try await db.collection("users").document(email).getDocument()
        guard let data = doc.data(),
              let roleString = data["role"] as? String,
              let role = UserRole(rawValue: roleString) else {
            throw NSError(domain: "FirestoreError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Role inválida ou documento inexistente"])
        }
        return role
    }
}
