//
//  EditOrderView.swift
//  OrderFlowWhiteLabel
//
//  Created by Bruno Teodoro on 26/11/25.
//

import SwiftUI

struct EditOrderView: View {
    var body: some View {
        VStack {
            
            ProductCartItemView(title: "Test", imageURL: <#T##String#>, unitPrice: <#T##Double#>, quantity: <#T##Binding<Int>#>, onIncrease: <#T##() -> Void#>, onDecrease: <#T##() -> Void#>, onDelete: <#T##() -> Void#>)
            
            IncreaseDecreaseComponent()
            
            OrderOverview(itemQuantity: 6, totalCost: 105.5)
            PrimaryButton(title: "Salvar Alterações") {
                
            }
            .padding(.top, 5)
            DangerButton(title: "Cancelar Edição") {
                
            }
            .padding(.top, 5)
        }
    }
}

struct ItemEditView: View {
    var body: some View {
        
    }
}

struct IncreaseDecreaseComponent: View {
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Text("-")
                    .font(.title)
                    .bold()
                    .foregroundStyle(DS.Colors.blueBase)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(DS.Colors.blueBase, lineWidth: 2)
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.white)
                            
                    )
            }
            .buttonStyle(.plain)
            .padding(.trailing, 40)
            
            Button {
                
            } label: {
                Text("-")
                    .font(.title)
                    .bold()
                    .foregroundStyle(DS.Colors.blueBase)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(DS.Colors.blueBase, lineWidth: 2)
                            .frame(width: 60, height: 40)
                            .foregroundStyle(.white)
                            
                    )
            }
            .buttonStyle(.plain)
            
            Button {
                
            } label: {
                Text("-")
                    .font(.title)
                    .bold()
                    .foregroundStyle(DS.Colors.blueBase)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(DS.Colors.blueBase, lineWidth: 2)
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.white)
                            
                    )
            }
            .buttonStyle(.plain)
            .padding(.leading, 40)
        }
    }
}

struct OrderOverview: View {
    
    var itemQuantity: Int
    var totalCost: Double
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Resumo do Pedido")
                .bold()
                .font(.title2)
            
            HStack {
                Text("Total de Itens:")
                Spacer()
                Text("\(itemQuantity)")
            }
            
            HStack {
                Text("Valor Total:")
                    .bold()
                    .font(.title2)
                Spacer()
                Text("R$ \(String(format: "%.2f", totalCost))")
                    .bold()
                    .font(.title2)
            }
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    EditOrderView()
}
