//
//  AuthService.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Eduardo on 04/11/25.
//

import Foundation
import FirebaseAuth

final class AuthService {
    static let shared = AuthService()

    private init() {}

    func register(email: String, password: String, name: String, phone: String, address: String, representativeEmail: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
        
        try await FirestoreManager.shared.createUserDocument(
                        email: email,
                        name: name,
                        phone: phone,
                        address: address,
                        representativeEmail: representativeEmail
                    )
        }

    func signIn(email: String, password: String) async throws {
            try await Auth.auth().signIn(withEmail: email, password: password)
        }
}
/***final class AuthService {
    static let shared = AuthService()

    private init() {}

    func register(email: String, password: String, representative: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        try await FirestoreManager.shared.createUserDocument(email: email)
    }

    func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
}
***/
