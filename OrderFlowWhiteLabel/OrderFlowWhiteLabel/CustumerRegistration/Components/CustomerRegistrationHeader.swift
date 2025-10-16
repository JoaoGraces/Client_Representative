//
//  CustomerRegistrationHeader.swift
//  Trabalho
//
//  Created by Scarllet Gomes on 15/10/25.
//

import SwiftUI

struct CustomerRegistrationHeader: View {
    var titleString: String
    var disclaimerString: String
    
    var body: some View {
        VStack(spacing: mediumVerticalPadding) {
            TitleView(text: titleString)
                .padding(.horizontal, horizontalPadding)
            
            DisclaimerView(text: disclaimerString)
                .padding(.horizontal, horizontalPadding)
        }
    }
}
