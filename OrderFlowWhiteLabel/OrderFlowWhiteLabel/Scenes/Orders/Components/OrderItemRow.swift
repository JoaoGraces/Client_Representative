//
//  OrderItemRow.swift
//  Trabalho
//
//  Created by Scarllet Gomes on 05/11/25.
//
import SwiftUI

struct MyOrderItemRow: View {
    let item: ItemPedido
    let produto: Produto
    
    var body: some View {
        HStack(spacing: DS.Spacing.insetX) {
            Image(systemName: "calendar")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 70, height: 70)
                .cornerRadius(DS.Radius.sm)
            
            VStack(alignment: .leading, spacing: DS.Spacing.smallPadding) {
                Text(produto.nome)
                    .font(DS.Typography.bodySemibold())
                    .lineLimit(2)
                
                Text(LocalizedStringKey("\(item.quantidade)" + "x R$" + "\(item.precoUnitarioMomento)"))
                    .foregroundStyle(DS.Colors.neutral700)
                    .font(DS.Typography.caption())
            }
            
            Spacer()
            
            Text(LocalizedStringKey("R$ " + "\(item.valorTotal)"))
                .font(DS.Typography.bodySemibold())
        }
        .padding(.horizontal)
    }
}
