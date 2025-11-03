//
//  ViewModelExample.swift
//  OrderFlowWhiteLabel
//
//  Created by João Victor Bernardes Gracês on 02/11/25.
//

import Foundation

@MainActor
final class UsersViewModel: ObservableObject {
    @Published var user: UserResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let apiProvider: APIProvider

    init(apiProvider: APIProvider = APIProvider()) {
        self.apiProvider = apiProvider
    }

    func fetchUser() async {
        isLoading = true
        errorMessage = nil

        do {
            let user: UserResponse = try await apiProvider.request(
                endpoint: "/users",
                method: .get,
                body: EmptyRequest(),
                responseType: UserResponse.self
            )

            self.user = user
        } catch let error as OrderFlowError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
