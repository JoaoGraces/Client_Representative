//
//  RefusedClientView.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Eduardo on 26/11/25.
//

import SwiftUI

struct RefusedClientView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "xmark")
                .font(.system(size: 48))
                .padding(.bottom, 8)
            Text("Você foi recusado")
                .font(.title2)
                .bold()
            Text("O representante que você escolheu recusou seu cadastro. Por favor, entre em contato com o suporte.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
