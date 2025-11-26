//
//  ConcellationConfirmationViewModel.swift
//  OrderFlowWhiteLabel
//
//  Created by Mirelle Alves Sine on 06/11/25.
//

import Foundation

final class ConfirmarCancelamentoViewModel: ObservableObject {
    @Published var justificativa: String = ""
    let ordem: OrderConfirmation
    let motivoCancelamento: String

    init(ordem: OrderConfirmation, motivoCancelamento: String) {
        self.ordem = ordem
        self.motivoCancelamento = motivoCancelamento
    }

    func aprovar() {
        // TODO: chamada para aprovar cancelamento
        print("Aprovar cancelamento do pedido \(ordem.orderIdText)")
    }

    func rejeitar() {
        // TODO: chamada para rejeitar cancelamento (usa justificativa se houver)
        print("Rejeitar cancelamento com justificativa: \(justificativa)")
    }
}
