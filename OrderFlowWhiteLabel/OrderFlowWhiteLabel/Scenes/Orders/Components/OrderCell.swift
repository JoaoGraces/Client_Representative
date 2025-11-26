//
//  OrderCell.swift
//  Trabalho
//
//  Created by Scarllet Gomes on 05/11/25.
//

import SwiftUI

struct OrderCell: View {
    var order: OrderConfirmation
    var empresa: Empresa
    var action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.smallPadding) {
            HStack {
                Text("PEDIDO #\(order.pedido.id)")
                    .font(DS.Typography.sectionTitle())
                
                Spacer()
                
                StatusBadge(status: order.pedido.status)
            }
            
            Text(empresa.nomeFantasia)
                .foregroundStyle(DS.Colors.neutral700)
                .font(DS.Typography.body())
            
            
            HStack() {
                Image(systemName: "calendar")
                    .foregroundColor(DS.Colors.neutral700)
                Text(DateFormatter.ptLong.string(from: order.pedido.dataEntregaSolicitada))
                    .font(DS.Typography.body())
            }
            
            HStack {
                Text(LocalizedStringKey("Total: R$" + "\(order.total.twoDecimals)"))
                    .font(DS.Typography.bodySemibold())
                
                Spacer()
                
                Text(String(order.itens.count) + " itens")
                    .font(DS.Typography.body())
            }
            
            Text(order.pedido.status.message())
                .font(DS.Typography.body())
            
            PrimaryButton(title: "Ver Detalhes") {
                action()
            }.padding(.vertical, DS.Spacing.smallPadding)
        }
    }
}

