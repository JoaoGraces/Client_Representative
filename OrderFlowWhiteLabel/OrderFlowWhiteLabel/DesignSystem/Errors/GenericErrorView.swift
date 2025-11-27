//
//  GenericErrorView.swift
//  OrderFlowWhiteLabel
//
//  Created by João Victor Bernardes Gracês on 27/11/25.
//

import SwiftUI

struct GenericErrorView: View {
    var message: String = "Algo deu errado. Tente novamente mais tarde."
    var retryAction: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray)
                .padding(.bottom, 8)
            
            Text(message)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            if let retryAction {
                Button(action: retryAction) {
                    Text("Tentar novamente")
                        .font(.body.weight(.semibold))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                }
            }
        }
        .padding()
    }
}

#Preview {
    GenericErrorView(retryAction: {
        print("Erro Generico Action")
    })
}
