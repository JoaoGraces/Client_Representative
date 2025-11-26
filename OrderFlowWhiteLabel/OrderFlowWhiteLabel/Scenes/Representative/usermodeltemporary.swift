//
//  usermodeltemporary.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Ribeiro Noronha on 26/11/25.
//

import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    
    let name: String
    let email: String
    let phone: String
    let address: String
    let role: String
    
    let representativeId: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case phone
        case address
        case role
        case representativeId = "representative_id"
    }
}
