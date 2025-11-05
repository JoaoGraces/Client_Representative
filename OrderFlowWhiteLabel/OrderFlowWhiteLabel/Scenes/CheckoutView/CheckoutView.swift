//
//  CheckoutView.swift
//  OrderFlowWhiteLabel
//
//  Created by Mirelle Alves Sine on 04/11/25.
//

import SwiftUI

struct KeyValueRow: View {
    let key: String
    let value: String
    var keyFont: Font = DS.Typography.body()
    var valueFont: Font = DS.Typography.body()
    var keyColor: Color = DS.Colors.neutral900
    var valueColor: Color = DS.Colors.neutral900
    var body: some View {
        HStack {
            Text(key).font(keyFont).foregroundStyle(keyColor)
            Spacer(minLength: 12)
            Text(value).font(valueFont).foregroundStyle(valueColor)
        }
        .padding(.horizontal, DS.Spacing.insetX)
        .padding(.vertical, 8)
    }
}

struct TotalRibbon: View {
    let title: String
    let value: String
    var body: some View {
        HStack {
            Text(title)
                .font(DS.Typography.button())
                .foregroundStyle(DS.Colors.white)
            Spacer()
            Text(value)
                .font(DS.Typography.button())
                .foregroundStyle(DS.Colors.white)
        }
        .padding(.horizontal, DS.Spacing.insetX)
        .frame(height: 40)
        .background(RoundedRectangle(cornerRadius: DS.Radius.sm, style: .continuous).fill(DS.Colors.blueBase))
        .padding(.horizontal, DS.Spacing.insetX)
        .padding(.vertical, 8)
    }
}

struct OrderItemRow: View {
    let item: Produto
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline) {
                Text(item.nome)
                    .font(DS.Typography.body())
                    .foregroundStyle(DS.Colors.neutral900)
                Spacer()
                Text("R$ \(item.preco.formattedMoney)")
                    .font(DS.Typography.body())
                    .foregroundStyle(DS.Colors.neutral900)
            }
            Text(item.descricao)
                .font(DS.Typography.caption())
                .foregroundStyle(DS.Colors.neutral700)
        }
        .padding(.horizontal, DS.Spacing.insetX)
        .padding(.vertical, 10)
    }
}

struct CheckoutView: View {
    let items: [Produto]
    let deliveryFee: Double

    @State private var path = NavigationPath()

    var subtotal: Double { items.reduce(0) { $0 + $1.preco } }
    var total: Double { subtotal + deliveryFee }

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 16) {
                ScrollView {
                    VStack(spacing: 16) {
                        DSCard {
                            DSSectionHeader(title: "Itens do Pedido")
                            ForEach(items.indices, id: \.self) { idx in
                                OrderItemRow(item: items[idx])
                                if idx < items.count - 1 { DSInsetDivider() }
                            }
                        }

                        DSCard {
                            DSSectionHeader(title: "Resumo do Pedido")
                            KeyValueRow(key: "Subtotal", value: "R$ \(subtotal.formattedMoney)")
                            KeyValueRow(key: "Entrega", value: "R$ \(deliveryFee.formattedMoney)")
                            TotalRibbon(title: "Total", value: "R$ \(total.formattedMoney)")
                        }

                        VStack(spacing: 12) {
                            PrimaryButton(title: "Enviar Pedido") {
                                enviarPedido()
                            }
                            SecondaryButton(title: "Editar Pedido") { /* ação */ }
                            DangerButton(title: "Cancelar Pedido") { /* ação */ }
                        }
                    }
                    .padding(.bottom, 24)
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Conferir Pedido")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: OrderConfirmation.self) { conf in
                OrderSentView(
                        viewModel: OrderSentViewModel(
                            data: conf,
                            onBackToCatalog: { path = NavigationPath() },
                            onSeeMyOrders: { /* navegar para "Meus Pedidos" */ }
                        )
                    )
            }
        }
    }

    private func enviarPedido() {
        let novoPedido = Pedido(
            id: UUID(),
            empresaClienteId: UUID(),
            usuarioCriadorId: UUID(),
            representanteId: UUID(),
            status: .criado, // ou .criado -> .enviado após request ao backend
            dataEntregaSolicitada: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date(),
            dataVencimentoPagamento: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(),
            statusRecebimento: nil,
            observacoesCliente: nil,
            dataCriacao: Date()
        )

        let confirmation = OrderConfirmation(
            pedido: novoPedido,
            itens: items,
            taxaEntrega: deliveryFee
        )

        path.append(confirmation)
    }
}

#Preview {
    CheckoutView(
        items: [
            Produto(id: .init(), distribuidoraId: .init(), nome: "Café Expresso Duplo", quantidade: 2, precoUnidade: 8.50, estoque: 100),
            Produto(id: .init(), distribuidoraId: .init(), nome: "Pão de Queijo Recheado", quantidade: 3, precoUnidade: 6.00, estoque: 50),
            Produto(id: .init(), distribuidoraId: .init(), nome: "Suco de Laranja Natural 500ml", quantidade: 1, precoUnidade: 12.00, estoque: 30),
            Produto(id: .init(), distribuidoraId: .init(), nome: "Bolo de Cenoura com Cobertura", quantidade: 1, precoUnidade: 15.00, estoque: 20),
            Produto(id: .init(), distribuidoraId: .init(), nome: "Misto Quente na Chapa", quantidade: 2, precoUnidade: 10.00, estoque: 40)
        ],
        deliveryFee: 7.50
    )
}
