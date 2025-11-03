//
//  OrderFlowError.swift
//  OrderFlowWhiteLabel
//
//  Created by João Victor Bernardes Gracês on 02/11/25.
//

import Foundation

// MARK: - GenericError
struct GenericError: Error, LocalizedError {
    let message: String
    
    var errorDescription: String? { message }
}

// MARK: - OrderFlowError
struct OrderFlowError: Error, LocalizedError {
    let message: String
    let statusCode: Int?
    
    var errorDescription: String? { message }
    
    init(message: String, statusCode: Int? = nil) {
        self.message = message
        self.statusCode = statusCode
    }
}
