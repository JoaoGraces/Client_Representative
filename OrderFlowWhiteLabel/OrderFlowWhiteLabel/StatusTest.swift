import SwiftUI

struct StatusTest: View {
    var body: some View {
        Button {
            Task {
                do {
                    try await OrderService.shared.updateOrderStatus(
                        forUserEmail: "johnDoes@example.com",
                        orderId: UUID(uuidString: "0F68B20B-6609-45E8-9A5D-72A1BEFC5CE6")!,
                        newStatus: .cancelamento
                    )
                    print("Status updated!")
                } catch {
                    print("Error updating status:", error)
                }
            }
        } label: {
            Text("GO!")
        }
    }
}

#Preview {
    StatusTest()
}

