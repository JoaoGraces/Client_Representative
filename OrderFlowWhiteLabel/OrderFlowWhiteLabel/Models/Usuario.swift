//
//  Usuario.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Ribeiro Noronha on 02/10/25.
//
import Foundation
import FirebaseFirestore

struct Usuario: Codable, Identifiable {
 let id: UUID
 let nomeCompleto: String
 let senha_hash: String
 let email: String
 let papel: UsuarioPapel
 let empresaId: UUID
 let dataCriacao: Date
 }
 
 enum UsuarioPapel: String, Codable {
 case adminCliente = "ADMIN_CLIENTE"
 case funcionarioCliente = "FUNCIONARIO_CLIENTE"
 case representante = "REPRESENTANTE"
 case adminDistribuidora = "ADMIN_DISTRIBUIDORA"
 }
 

//esse é o model do Firebase
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

