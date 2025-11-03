//
//  ApiProvider.swift
//  OrderFlowWhiteLabel
//
//  Created by João Victor Bernardes Gracês on 02/11/25.
//

import Foundation

import Foundation

final class APIProvider {
    
    private let baseURL = URL(string: "http://localhost:8080")!
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<Request: Encodable, Response: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        body: Request? = nil,
        responseType: Response.Type
    ) async throws -> Response {
        
        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            throw GenericError(message: "URL inválida")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Codifica body se necessário
        var bodyData: Data? = nil
        if method != .get, let body = body {
            bodyData = try JSONEncoder().encode(body)
            request.httpBody = bodyData
        }
        
        // --- DEBUG: Solicitação ---
        print("[API Request]")
        print("URL: \(request.url?.absoluteString ?? "nil")")
        print("Method: \(method.rawValue)")
        if let bodyData = bodyData, let bodyString = String(data: bodyData, encoding: .utf8) {
            print("Body: \(bodyString)")
        } else {
            print("Body: nil")
        }
        print("-------------------------")
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw GenericError(message: "Resposta inválida do servidor")
            }
            
            // --- DEBUG: Resposta recebida ---
            print(" [API Response]")
            print("Status code: \(httpResponse.statusCode)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("Body: \(responseString)")
            }
            print("-------------------------")
            
            // Se statusCode não for 2xx, lança erro
            guard 200..<300 ~= httpResponse.statusCode else {
                let bodyMessage = String(data: data, encoding: .utf8) ?? "Sem corpo"
                print("[API Error Detected]")
                print("Status code: \(httpResponse.statusCode), Body: \(bodyMessage)")
                throw OrderFlowError(
                    message: "Erro na requisição: \(bodyMessage)",
                    statusCode: httpResponse.statusCode
                )
            }
            
            // Tenta decodificar a resposta
            do {
                let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
                print(" [API Success] Decoded Response: \(decodedResponse)")
                return decodedResponse
            } catch {
                print(" [Decoding Error] Data: \(String(data: data, encoding: .utf8) ?? "nil")")
                throw GenericError(message: "Falha ao decodificar resposta")
            }
            
        } catch let urlError as URLError {
            print(" [Network Error] \(urlError)")
            throw GenericError(message: "Erro de rede: \(urlError.localizedDescription)")
        } catch let error as OrderFlowError {
            print(" [OrderFlowError] Status: \(error.statusCode ?? 0), Message: \(error.message)")
            throw error
        } catch {
            print(" [Unknown Error] \(error)")
            throw GenericError(message: "Erro desconhecido: \(error.localizedDescription)")
        }
    }
}



struct UserResponse: Codable {
    let name: String
    let age: Int
}

