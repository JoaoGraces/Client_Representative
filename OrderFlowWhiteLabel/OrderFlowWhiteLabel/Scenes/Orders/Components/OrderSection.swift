//
//  OrderSection.swift
//  OrderFlowWhiteLabel
//
//  Created by Scarllet Gomes on 06/11/25.
//

import SwiftUI

struct OrderSection<Content: View>: View {
    let content: Content
    var title: String
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.title = title
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.insetX){
            DSSectionHeader(title: title)
            
            content
            
            DSInsetDivider()
        }
        
    }
}
