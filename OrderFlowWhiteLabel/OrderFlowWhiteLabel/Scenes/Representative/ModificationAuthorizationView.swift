//
//  ModificationView.swift
//  OrderFlowWhiteLabel
//
//  Created by Gabriel Ribeiro Noronha on 06/11/25.
//

import SwiftUI

struct AuthoredOrderItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let originalQuantity: Int?
    let modifiedQuantity: Int?
    let originalPrice: Double
    
    var changeDescription: String {
        switch (originalQuantity, modifiedQuantity) {
        case let (.some(orig), .some(mod)) where orig < mod: return "\(orig) -> \(mod)"
        case let (.some(orig), .some(mod)) where orig > mod: return "\(orig) -> \(mod)"
        case let (.some(orig), .none): return "\(orig) -> Removido"
        case let (.none, .some(mod)): return "0 -> \(mod)"
        default: return ""
        }
    }
}

struct OrderModificationDetails: Identifiable {
    let id: String
    let clientName: String
    let orderDate: String
    let originalTotal: Double
    let modifiedItems: [AuthoredOrderItem]
    let modifiedTotal: Double
    let justification: String?
}


// MARK: - View Principal
struct ModificationAuthorizationView: View {
    
    @Environment(\.dismiss) var dismiss
    let modificationDetails: OrderModificationDetails
    
    @State private var justificationText: String = ""
    
    init(modificationDetails: OrderModificationDetails = .mock) {
        self.modificationDetails = modificationDetails
        _justificationText = State(initialValue: modificationDetails.justification ?? "")
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                // MARK: - Detalhes do Pedido Original
                DSCard {
                    VStack(spacing: 8) {
                        HStack {
                            DSSectionHeader(title: "Detalhes do Pedido")
                            
                            Text(modificationDetails.id)
                                .font(DS.Typography.body())
                                .bold()
                                .foregroundStyle(DS.Colors.blueBase)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                                .background(RoundedRectangle(cornerRadius: DS.Radius.sm)
                                    .fill(DS.Colors.blueBase.opacity(0.1)))
                        }
                        .padding(.horizontal, DS.Spacing.insetX)
                        
                        KeyValueRow(key: "Cliente:", value: modificationDetails.clientName)
                        KeyValueRow(key: "Data do Pedido:", value: modificationDetails.orderDate)
                        KeyValueRow(key: "Total Original:", value: modificationDetails.originalTotal.formattedMoney)
                    }
                }
                
                // MARK: - Alterações Solicitadas
                DSCard {
                    VStack(spacing: 8) {
                        DSSectionHeader(title: "Alterações Solicitadas")
                        
                        ForEach(modificationDetails.modifiedItems) { item in
                            HStack {
                                Text(item.name)
                                    .font(DS.Typography.body())
                                    .foregroundStyle(DS.Colors.neutral900)
                                
                                Spacer()
                                
                                Text(item.changeDescription)
                                    .font(DS.Typography.body())
                                    .foregroundStyle(item.modifiedQuantity == nil ? DS.Colors.redBase : (item.originalQuantity == nil ? Color.green : DS.Colors.blueBase))
                            }
                            .padding(.horizontal, DS.Spacing.insetX)
                            .padding(.vertical, 4)
                            
                            if item != modificationDetails.modifiedItems.last {
                                DSInsetDivider()
                            }
                        }
                        
                        DSInsetDivider()
                        
                        KeyValueRow(
                            key: "Total Alterado",
                            value: modificationDetails.modifiedTotal.formattedMoney,
                            keyFont: DS.Typography.button(),
                            valueFont: DS.Typography.button(),
                            keyColor: DS.Colors.neutral900,
                            valueColor: DS.Colors.neutral900
                        )
                        .padding(.top, 8)
                    }
                }
                
                // MARK: - Justificativa (Opcional)
                DSCard {
                    VStack(alignment: .leading, spacing: 8) {
                        DSSectionHeader(title: "Justificativa (Opcional)")
                        
                        TextEditor(text: $justificationText)
                            .frame(height: 100)
                            .padding(8)
                            .background(RoundedRectangle(cornerRadius: DS.Radius.sm).stroke(DS.Colors.neutral300, lineWidth: 1))
                            .overlay(alignment: .topLeading) {
                                if justificationText.isEmpty {
                                    Text("Adicione sua justificativa aqui...")
                                        .font(DS.Typography.body())
                                        .foregroundStyle(DS.Colors.neutral700)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                }
                            }
                    }
                }
                
                // MARK: - Botões de Ação
                VStack(spacing: 12) {
                    PrimaryButton(title: "Aprovar Alteração") {
                        print("Aprovar Alteração clicado.")
                    }
                    SecondaryButton(title: "Rejeitar Alteração") {
                        print("Rejeitar Alteração clicado.")
                    }
                }
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("Autorizar Alteração")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
    }
}


// MARK: - Dados de Mock (Usando o formattedMoney do seu DS.swift)
extension OrderModificationDetails {
    static let mock = OrderModificationDetails(
        id: "#ORD-2023001",
        clientName: "Cliente Exemplo Ltda.",
        orderDate: "2023-10-26",
        originalTotal: 1500.00,
        modifiedItems: [
            AuthoredOrderItem(name: "Produto A", originalQuantity: 2, modifiedQuantity: 3, originalPrice: 100.0),
            AuthoredOrderItem(name: "Produto B", originalQuantity: 5, modifiedQuantity: nil, originalPrice: 50.0),
            AuthoredOrderItem(name: "Produto C", originalQuantity: nil, modifiedQuantity: 1, originalPrice: 200.0)
        ],
        modifiedTotal: 1700.00,
        justification: nil
    )
}

// MARK: - Preview
#Preview {
    NavigationView {
        ModificationAuthorizationView(modificationDetails: .mock)
    }
}
