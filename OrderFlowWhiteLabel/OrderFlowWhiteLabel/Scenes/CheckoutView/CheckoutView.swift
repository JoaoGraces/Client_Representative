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
    let item: CartItemModel
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline) {
                Text(item.product.nome)
                    .font(DS.Typography.body())
                    .foregroundStyle(DS.Colors.neutral900)
                Spacer()
                Text("R$ \(item.price.formattedMoney)")
                    .font(DS.Typography.body())
                    .foregroundStyle(DS.Colors.neutral900)
            }
            Text("\(item.quantity) x R$ \(item.product.precoUnidade.formattedMoney)/un.")
                .font(DS.Typography.caption())
                .foregroundStyle(DS.Colors.neutral700)
        }
        .padding(.horizontal, DS.Spacing.insetX)
        .padding(.vertical, 10)
    }
}

struct CheckoutView: View {
    let items: [CartItemModel]
    let deliveryFee: Double

    @ObservedObject var coordinator: CartCoordinator
    @ObservedObject var viewModel: ProductListViewModel

    var subtotal: Double { items.reduce(0) { $0 + $1.price } }
    var total: Double { subtotal + deliveryFee }

    var body: some View {

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
                            SecondaryButton(title: "Editar Pedido") { coordinator.back() }
                            DangerButton(title: "Cancelar Pedido") { viewModel.clearCart()
                                coordinator.backToRoot()
                            }
                        }
                    }
                    .padding(.bottom, 24)
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .navigationTitle("Conferir Pedido")
            .navigationBarTitleDisplayMode(.inline)
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
            itens: items.map { $0.product },
            taxaEntrega: deliveryFee
        )
        
        viewModel.createOrderConfirmation(with: confirmation)
        coordinator.go(to: .orderConfirmation(confirmation))
    }
}

#Preview {
    CheckoutView(
        items: [
            CartItemModel(product: Produto(id: .init(), distribuidoraId: .init(), nome: "Café Expresso Duplo", quantidade: 2, precoUnidade: 8.50, estoque: 100, imageName: "", tagText: ""), quantity: 9),
            CartItemModel(product: Produto(id: .init(), distribuidoraId: .init(), nome: "Pão de Queijo Recheado", quantidade: 3, precoUnidade: 6.00, estoque: 50, imageName: "", tagText: ""), quantity: 7),
            CartItemModel(product: Produto(id: .init(), distribuidoraId: .init(), nome: "Suco de Laranja Natural 500ml", quantidade: 1, precoUnidade: 12.00, estoque: 30, imageName: "", tagText: ""), quantity: 6),
            CartItemModel(product: Produto(id: .init(), distribuidoraId: .init(), nome: "Bolo de Cenoura com Cobertura", quantidade: 1, precoUnidade: 15.00, estoque: 20, imageName: "", tagText: ""), quantity: 2),
            CartItemModel(product: Produto(id: .init(), distribuidoraId: .init(), nome: "Misto Quente na Chapa", quantidade: 2, precoUnidade: 10.00, estoque: 40, imageName: "", tagText: ""), quantity: 2)
        ],
        deliveryFee: 7.50, coordinator: CartCoordinator(), viewModel: ProductListViewModel()
    )
}
