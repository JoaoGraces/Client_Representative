//
//  CancelReasonModal.swift
//  OrderFlowWhiteLabel
//
//  Created by Scarllet Gomes on 06/11/25.
//
import SwiftUI

struct CancelReasonModal: View {
    @Binding var text: String
    var body: some View {
        VStack{
            DSSectionHeader(title: "Motivo do cancelamento")
            
            DSTextFieldCard{
                ZStack{
                    TextField("Descreva o motivo do cancelamento", text: $text, axis: .vertical)
                        .lineLimit(1...5)
                        .frame(minHeight: 150)
                        .foregroundStyle(DS.Colors.shadowXS1)
                        .padding()
                }
            }
        }
    }
}

#Preview {
    CancelReasonModal(text: .constant("Teste"))
}
