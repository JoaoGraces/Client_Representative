//
//  ClienteRepresentante.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Ribeiro Noronha on 02/10/25.
//
import Foundation

struct ClienteRepresentante: Codable, Hashable {
    let empresaClienteId: UUID
    let usuarioRepresentanteId: UUID
}
