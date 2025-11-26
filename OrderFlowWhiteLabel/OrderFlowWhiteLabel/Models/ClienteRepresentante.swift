//
//  ClienteRepresentante.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Ribeiro Noronha on 02/10/25.
//
import Foundation
import FirebaseFirestore

struct Representative: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    let name: String
    let email: String
}
