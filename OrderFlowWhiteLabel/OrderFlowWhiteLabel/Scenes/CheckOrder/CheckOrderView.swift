//
//  CheckOrderView.swift
//  OrderFlowWhiteLabel
//
//  Created by Bruno Teodoro on 26/11/25.
//

import SwiftUI

struct CheckOrderView: View {
    var body: some View {
        
        VStack {
            OrderStatus(orderCode: "#OF-2023-00145", orderStatus: "Entregue", orderDate: "24 de Outubro, 2023")
                .padding(.vertical)
            DSInsetDivider()
            
            DSInsetDivider()
                .padding(.top, 5)

            
            ClientInfoView(clientName: "Maria Silva", address: "Rua das Flores, 123, Bairro Jardim, Cidade Nova - SP", contactNumber: "(11) 98765-4321")
                        
            Text("Itens do Pedido")
                .bold()
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            
            OrderItemCheckView(itemName: "Cafeteira Expresso Premium", itemQuantity: 1, price: 299.99)

            
            TotalOrderPriceView(totalPrice: 509.89)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground)) // or Color.white
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
        )
        .padding(.horizontal) 

        PrimaryButton(title: "Confirmar Recebimento") {
            
        }
        .padding(.horizontal, 5)
        .padding(.top, 10)
    }
}

struct OrderItemCheckView: View {
    
    var itemName: String
    var itemQuantity: Int
    var price: Double
    
    var body: some View {
        VStack {
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 70, height: 70)
                    .foregroundStyle(Color.gray.opacity(0.2))
                    .overlay(
                        ProgressView()
                    )
                
                VStack(alignment: .leading) {
                    Text(itemName)
                        .bold()
                        .font(.title2)
                    
                    Text("Qtd: \(itemQuantity)")
                        .padding(.top, 5)
                }
                
                Text("R$ \(String(format: "%.2f", price))")
                    .font(.title3)
                    .bold()
                    .padding(.leading, 30)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 30)
            
            DSInsetDivider()
        }
    }
}

struct OrderStatus: View {
    
    var orderCode: String
    var orderStatus: String
    var orderDate: String
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Pedido \(orderCode)")
                .font(.title2)
                .bold()
            
            HStack {
                Spacer()
                Text(orderStatus)
                    .bold()
            }
            
            Text(orderDate)
        }
        .padding(.horizontal, 20)
    }
}

struct ClientInfoView: View {
    
    var clientName: String
    var address: String
    var contactNumber: String
    
    var body: some View {
        
            VStack (alignment: .leading) {
                Text("Informações do Cliente e Entrega")
                    .bold()
                    .font(.title2)
                HStack {
                    Text("Cliente: \(clientName)")
                        .bold()
                    Text("\(clientName)")
                }
                HStack {
                    Text("Endereço: \(clientName)")
                        .bold()
                    Text("\(address)")
                }
                HStack {
                    Text("Contato: \(clientName)")
                        .bold()
                    Text("\(contactNumber)")
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 30)
        
    }
}

struct TotalOrderPriceView: View {
    
    var totalPrice: Double
    
    var body: some View {
        HStack {
            Text("Total")
                .bold()
                .font(.title2)
            Spacer()
            Text("R$ \(String(format: "%.2f", totalPrice))")
                .font(.title3)
                .bold()
                .foregroundStyle(DS.Colors.blueBase)
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    CheckOrderView()
}
