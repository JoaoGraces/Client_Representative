//
//  OrderSentView.swift
//  OrderFlowWhiteLabel
//
//  Created by Mirelle Alves Sine on 04/11/25.
//

import SwiftUI

struct OrderDetailRow: View {
    let key: String
    let value: String
    var keyFont: Font = DS.Typography.body()
    var valueFont: Font = DS.Typography.body()
    var keyColor: Color = DS.Colors.neutral900
    var valueColor: Color = DS.Colors.neutral900

    var body: some View {
        HStack {
            Text(key).font(keyFont).foregroundStyle(keyColor)
            Spacer()
            Text(value).font(valueFont).foregroundStyle(valueColor)
        }
        .padding(.horizontal, DS.Spacing.insetX)
        .padding(.vertical, 10)
    }
}

import SwiftUI

struct OrderSentView: View {
    let orderId: String
    let dateString: String
    let status: String
    let itemsCountText: String
    let total: String
    var onBackToCatalog: () -> Void = {}
    var onSeeMyOrders: () -> Void = {}

    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            CircleCheckIcon()
                                .padding(.top, 24)
                            Text("Pedido Enviado com Sucesso!")
                                .font(DS.Typography.displaySuccess())
                                .foregroundStyle(DS.Colors.neutral900)
                                .multilineTextAlignment(.center)
                            Text("Sua solicitação foi processada e está a caminho.\nVocê pode verificar os detalhes abaixo.")
                                .font(DS.Typography.caption())
                                .foregroundStyle(DS.Colors.neutral700)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                        }

                        DSCard {
                            DSSectionHeader(title: "Detalhes do Pedido")
                            OrderDetailRow(key: "Número do Pedido:", value: orderId,
                                           keyFont: DS.Typography.body(),
                                           valueFont: DS.Typography.bodySemibold(),
                                           keyColor: DS.Colors.neutral700,
                                           valueColor: DS.Colors.neutral900)
                            OrderDetailRow(key: "Data:", value: dateString,
                                           keyFont: DS.Typography.body(),
                                           valueFont: DS.Typography.bodySemibold(),
                                           keyColor: DS.Colors.neutral700,
                                           valueColor: DS.Colors.neutral900)
                            OrderDetailRow(key: "Status:", value: status,
                                           keyFont: DS.Typography.body(),
                                           valueFont: DS.Typography.bodySemibold(),
                                           keyColor: DS.Colors.neutral700,
                                           valueColor: DS.Colors.neutral900)
                            OrderDetailRow(key: "Itens:", value: itemsCountText,
                                           keyFont: DS.Typography.body(),
                                           valueFont: DS.Typography.bodySemibold(),
                                           keyColor: DS.Colors.neutral700,
                                           valueColor: DS.Colors.neutral900)
                            DSDashedDivider()
                            OrderDetailRow(key: "Total:", value: total,
                                           keyFont: DS.Typography.sectionTitle(),
                                           valueFont: DS.Typography.sectionTitle(),
                                           keyColor: DS.Colors.neutral900,
                                           valueColor: DS.Colors.neutral900)
                                .padding(.top, 4)
                        }

                        VStack(spacing: 12) {
                            PrimaryButton(title: "Retornar ao Catálogo", action: onBackToCatalog)
                            SecondaryButton(title: "Ver Meus Pedidos", action: onSeeMyOrders)
                        }
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationTitle("Pedido Enviado")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    OrderSentView(
        orderId: "#OFP20231026-001",
        dateString: "26 de Outubro, 2023",
        status: "Confirmado",
        itemsCountText: "3 produtos",
        total: "R$ 150,00"
    )
}
