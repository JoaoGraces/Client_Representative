//
//  TextComponents.swift
//  Trabalho
//
//  Created by Scarllet Gomes on 15/10/25.
//

import SwiftUI

struct TitleView: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.system(.title, design: .default, weight: .bold))
    }
}

struct DisclaimerView: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.system(.subheadline, design: .default, weight: .regular))
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
    }
}

struct ButtonTextView: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.system(.subheadline, design: .default, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(cornerRadiusPattern)
    }
}

struct FooterLinkTextView: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.system(.subheadline, design: .default, weight: .regular))
            .foregroundColor(.blue)
            .multilineTextAlignment(.center)
    }
}


#Preview {
    CustomerRegistrationView()
}
