//
//  PendingView.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Eduardo on 04/11/25.
//

import SwiftUI

struct PendingView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "hourglass")
                .font(.system(size: 48))
                .padding(.bottom, 8)
            Text("Seu cadastro está sendo analisado")
                .font(.title2)
                .bold()
            Text("Obrigado por se cadastrar — você terá acesso assim que analisarmos suas informações. Volte novamente mais tarde!")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
