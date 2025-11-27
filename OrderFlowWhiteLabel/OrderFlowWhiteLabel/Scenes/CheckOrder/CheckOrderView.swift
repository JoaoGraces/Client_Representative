//
//  CheckOrderView.swift
//  OrderFlowWhiteLabel
//
//  Created by Bruno Teodoro on 26/11/25.
//

import SwiftUI

struct CheckOrderView: View {
    
    let pedido: Pedido
    let user: User
    
    var body: some View {
        
        VStack {
            OrderStatus(
                orderCode: pedido.id.uuidString,
                orderStatus: pedido.status.rawValue,
                orderDate: {
                    let df = DateFormatter()
                    df.locale = Locale(identifier: "pt_BR")
                    df.dateFormat = "dd/MM/yyyy"   // customize here
                    return df.string(from: pedido.dataCriacao)
                }()
            )
                .padding(.vertical)
            DSInsetDivider()
            
            DSInsetDivider()
                .padding(.top, 5)

            
            ClientInfoView(clientName: user.name, address: user.address, contactNumber: user.phone)
                        
            Text("Itens do Pedido")
                .bold()
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            
            ForEach(pedido.produtos, id: \.id) { produto in
                OrderItemCheckView(
                    itemName: produto.nome,
                    itemQuantity: produto.quantidade,
                    price: produto.precoUnidade,
                    imageName: produto.imageName
                )
            }
            
            TotalOrderPriceView(totalPrice: pedido.total)
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
    var imageName: String? = nil
    
    var body: some View {
        VStack {
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 70, height: 70)
                    .foregroundStyle(Color.gray.opacity(0.2))
                    .overlay(
                        Group {
                            if let imageName = imageName,
                               !imageName.isEmpty,
                               UIImage(named: imageName) != nil {
                                
                                Image(imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                            } else {
                                ProgressView()
                            }
                        }
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
            
            Text("Pedido #\(orderCode)")
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
                    Text("Cliente: ")
                        .bold()
                    Text("\(clientName)")
                }
                HStack {
                    Text("Endereço: ")
                        .bold()
                    Text("\(address)")
                }
                HStack {
                    Text("Contato: ")
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
    
    let mockProdutos: [Produto] = [
        Produto(
            id: UUID(),
            distribuidoraId: UUID(),
            nome: "Água Mineral 500ml",
            quantidade: 2,
            precoUnidade: 3.50,
            estoque: 120,
            imageName: "agua",
            tagText: "Bebidas"
        ),
        Produto(
            id: UUID(),
            distribuidoraId: UUID(),
            nome: "Refrigerante Cola 2L",
            quantidade: 1,
            precoUnidade: 8.99,
            estoque: 50,
            imageName: "refri",
            tagText: "Bebidas"
        )
    ]

    let mockPedido = Pedido(
        id: UUID(),
        empresaClienteId: UUID(),
        usuarioCriadorId: UUID(),
        representanteId: UUID(),
        status: .criado,
        dataEntregaSolicitada: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
        dataVencimentoPagamento: Calendar.current.date(byAdding: .day, value: 10, to: Date())!,
        statusRecebimento: nil,
        observacoesCliente: "Entregar no período da manhã.",
        dataCriacao: Date(),
        produtos: mockProdutos,
        taxaEntrega: 12.0
    )
    
    let mockUser = User(
        id: "user_12345",
        name: "Maria Silva",
        email: "mariasilva@example.com",
        phone: "+55 11 98765-4321",
        address: "Rua das Flores, 123 - São Paulo, SP",
        role: .client,
        representativeId: "rep_98765"
    )
    
    CheckOrderView(pedido: mockPedido, user: mockUser)
}

