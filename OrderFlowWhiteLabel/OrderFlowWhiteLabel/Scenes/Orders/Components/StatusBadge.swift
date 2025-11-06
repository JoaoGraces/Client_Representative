//
//  StatusBadge.swift
//  Trabalho
//
//  Created by Scarllet Gomes on 05/11/25.
//

import SwiftUI

struct StatusBadge: View {
    let status: PedidoStatus
    
    var body: some View {
        VStack{
            Text(status.rawValue)
                .font(DS.Typography.caption())
                .foregroundColor(status == .criado ? .black : .white)
                .padding(DS.Spacing.smallPadding)
                .background(status.getColor())
                .cornerRadius(DS.Radius.pill)
        }
    }
}

#Preview {
    StatusBadge(status: .alteracao)
}
