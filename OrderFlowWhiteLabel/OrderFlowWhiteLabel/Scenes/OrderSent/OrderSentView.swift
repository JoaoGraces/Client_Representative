//
//  OrderSentView.swift
//  OrderFlowWhiteLabel
//
//  Created by Mirelle Alves Sine on 04/11/25.
//

import SwiftUI

// OrderSentView.swift
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

struct OrderSentView: View {
    @StateObject var viewModel: OrderSentViewModel

    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        CircleCheckIcon().padding(.top, 24)
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

                        OrderDetailRow(
                            key: "Número do Pedido:",
                            value: viewModel.orderIdText,
                            keyFont: DS.Typography.body(),
                            valueFont: DS.Typography.bodySemibold(),
                            keyColor: DS.Colors.neutral700,
                            valueColor: DS.Colors.neutral900
                        )
                        OrderDetailRow(
                            key: "Data:",
                            value: viewModel.dateString,
                            keyFont: DS.Typography.body(),
                            valueFont: DS.Typography.bodySemibold(),
                            keyColor: DS.Colors.neutral700,
                            valueColor: DS.Colors.neutral900
                        )
                        OrderDetailRow(
                            key: "Status:",
                            value: viewModel.statusText,
                            keyFont: DS.Typography.body(),
                            valueFont: DS.Typography.bodySemibold(),
                            keyColor: DS.Colors.neutral700,
                            valueColor: DS.Colors.neutral900
                        )
                        OrderDetailRow(
                            key: "Itens:",
                            value: viewModel.itemsCountText,
                            keyFont: DS.Typography.body(),
                            valueFont: DS.Typography.bodySemibold(),
                            keyColor: DS.Colors.neutral700,
                            valueColor: DS.Colors.neutral900
                        )

                        DSDashedDivider()

                        OrderDetailRow(
                            key: "Total:",
                            value: viewModel.totalText,
                            keyFont: DS.Typography.sectionTitle(),
                            valueFont: DS.Typography.sectionTitle(),
                            keyColor: DS.Colors.neutral900,
                            valueColor: DS.Colors.neutral900
                        )
                        .padding(.top, 4)
                    }

                    VStack(spacing: 12) {
                        PrimaryButton(title: "Retornar ao Catálogo") {
                            viewModel.handleBackToCatalog()
                        }
                        SecondaryButton(title: "Ver Meus Pedidos") {
                            viewModel.handleSeeMyOrders()
                        }
                    }
                    .padding(.bottom, 24)
                }
            }
        }
        .navigationTitle("Pedido Enviado")
        .navigationBarTitleDisplayMode(.inline)
    }
}



// OrderSentView_Previews.swift
#Preview {
    let pedidoExemplo = Pedido(
        id: UUID(),
        empresaClienteId: UUID(),
        usuarioCriadorId: UUID(),
        representanteId: UUID(),
        status: .enviado,
        dataEntregaSolicitada: Date(),
        dataVencimentoPagamento: Date().addingTimeInterval(86400 * 7),
        statusRecebimento: nil,
        observacoesCliente: "Entregar na portaria",
        dataCriacao: Date()
    )

    let produtosExemplo = [
        Produto(id: UUID(), distribuidoraId: UUID(), nome: "Café Expresso Duplo", quantidade: 2, precoUnidade: 8.50, estoque: 100),
        Produto(id: UUID(), distribuidoraId: UUID(), nome: "Pão de Queijo Recheado", quantidade: 3, precoUnidade: 6.00, estoque: 50),
        Produto(id: UUID(), distribuidoraId: UUID(), nome: "Suco de Laranja Natural 500ml", quantidade: 1, precoUnidade: 12.00, estoque: 30)
    ]

    let confirmation = OrderConfirmation(
        pedido: pedidoExemplo,
        itens: produtosExemplo,
        taxaEntrega: 7.50
    )

    let vm = OrderSentViewModel(
        data: confirmation,
        onBackToCatalog: { print("Voltar ao catálogo") },
        onSeeMyOrders: { print("Ver meus pedidos") }
    )

    return NavigationStack {
        OrderSentView(viewModel: vm)
    }
}
