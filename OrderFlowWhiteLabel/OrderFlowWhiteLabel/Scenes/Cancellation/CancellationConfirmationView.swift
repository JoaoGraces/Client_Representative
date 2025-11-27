//
//  CancellationConfirmationView.swift
//  OrderFlowWhiteLabel
//
//  Created by Mirelle Alves Sine on 06/11/25.
//

import SwiftUI

struct ConfirmarCancelamentoView: View {
    @StateObject var vm: ConfirmarCancelamentoViewModel

    var body: some View {
        VStack(spacing: 16) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // CARD – Cabeçalho + infos do pedido
                    DSCard {
                        VStack(alignment: .leading, spacing: 12) {
                            // Título + badge de status
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Pedido ID:")
                                        .font(DS.Typography.body())
                                        .foregroundStyle(DS.Colors.neutral700)
                                    Text(vm.ordem.orderIdText.replacingOccurrences(of: "#", with: ""))
                                        .font(DS.Typography.bodySemibold())
                                        .foregroundStyle(DS.Colors.neutral900)
                                }

                                Spacer(minLength: 8)

                                DS.StatusBadge(text: "Pendente Cancelamento")
                            }
                            .padding(.horizontal, DS.Spacing.insetX)

                            DSInsetDivider()

                            DS.KeyValueRow(
                                title: "Data",
                                value: vm.ordem.dataString
                            )

                            DS.KeyValueRow(
                                title: "Cliente",
                                value: "Maria Silva Comércio Ltda."
                            )

                            DS.KeyValueRow(
                                title: "Valor Total",
                                value: "R$ \(vm.ordem.total.formattedMoney)"
                            )

                            DS.KeyValueRow(
                                title: "Itens no Pedido",
                                value: vm.ordem.itensCountText
                            )

                            DS.KeyValueRow(
                                title: "Motivo do Cancelamento",
                                value: vm.motivoCancelamento,
                                valueFont: DS.Typography.body()
                            )
                        }
                    }

                    // Seção Justificativa
                    VStack(alignment: .leading, spacing: 8) {
                        DSSectionHeader(title: "Justificativa (Opcional)")
                        DS.TextArea(
                            placeholder: "Adicione uma justificativa para a rejeição do cancelamento, se necessário.",
                            text: $vm.justificativa
                        )
                    }
                }
                .padding(.top, 8)
            }

            // Botões inferiores
            VStack(spacing: 12) {
                PrimaryButton(title: "Aprovar Cancelamento") {
                    vm.aprovar()
                }

                DangerButton(title: "Rejeitar Cancelamento") {
                    vm.rejeitar()
                }
            }
            .padding(.bottom, 12)
        }
        .navigationTitle("Confirmar Cancelamento")
        .navigationBarTitleDisplayMode(.inline)
        .background(DS.Colors.neutral300.opacity(0.35).ignoresSafeArea())
    }
}

struct ConfirmarCancelamentoView_Previews: PreviewProvider {
    static var previews: some View {
        let pedido = Pedido(
            id: UUID(),
            empresaClienteId: UUID(),
            usuarioCriadorId: UUID(),
            representanteId: UUID(),
            status: .criado,
            dataEntregaSolicitada: Date(),
            dataVencimentoPagamento: Date(),
            statusRecebimento: nil,
            observacoesCliente: nil,
            dataCriacao: ISO8601DateFormatter().date(from: "2024-04-23T10:30:00Z") ?? Date(),
            produtos: [],
            taxaEntrega: 1
        )

        let itens = [
            Produto(id: UUID(), distribuidoraId: UUID(), nome: "Produto A", quantidade: 2, precoUnidade: 250, estoque: 10, imageName: "", tagText: ""),
            Produto(id: UUID(), distribuidoraId: UUID(), nome: "Produto B", quantidade: 3, precoUnidade: 250, estoque: 5, imageName: "", tagText: "")
        ]

        let ordem = OrderConfirmation(pedido: pedido, itens: itens, taxaEntrega: 250)

        NavigationView {
            ConfirmarCancelamentoView(
                vm: .init(
                    ordem: ordem,
                    motivoCancelamento: "Cliente solicitou a alteração de um item que não está mais em estoque. Preferiu cancelar e refazer o pedido."
                )
            )
        }
    }
}
