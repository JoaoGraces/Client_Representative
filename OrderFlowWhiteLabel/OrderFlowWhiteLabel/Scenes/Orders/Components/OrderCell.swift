//
//  OrderCell.swift
//  Trabalho
//
//  Created by Scarllet Gomes on 05/11/25.
//

import SwiftUI

struct OrderCell: View {
    var order: Pedido
    var action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.smallPadding) {
            HStack {
                Text("PEDIDO #\(order.id.uuidString.suffix(6))")
                    .font(DS.Typography.sectionTitle())
                
                Spacer()
                
                StatusBadge(status: order.status)
            }
            
            
            HStack() {
                Image(systemName: "calendar")
                    .foregroundColor(DS.Colors.neutral700)
                Text(DateFormatter.ptLong.string(from: order.dataEntregaSolicitada))
                    .font(DS.Typography.body())
            }
            
            HStack {
                Text(LocalizedStringKey("Total: R$" + "\(order.total.twoDecimals)"))
                    .font(DS.Typography.bodySemibold())
                
                Spacer()
                
                Text(String(order.produtos.count) + " itens")
                    .font(DS.Typography.body())
            }
            
            Text(order.status.message())
                .font(DS.Typography.body())
            
            PrimaryButton(title: "Ver Detalhes") {
                action()
            }.padding(.vertical, DS.Spacing.smallPadding)
        }
    }
}

