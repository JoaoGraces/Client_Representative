//
//  CatalogItemView.swift
//  OrderFlowWhiteLabel
//
//  Created by João Victor Bernardes Gracês on 03/11/25.
//

import SwiftUI

struct ProductItemView: View {
    // MARK: - Constants
    enum Layout {
        static let width: CGFloat = 171
        static let height: CGFloat = 254
        static let imageHeight: CGFloat = 140
        static let tagTopPadding: CGFloat = 8
        static let tagLeadingPadding: CGFloat = 8
        static let contentHorizontalPadding: CGFloat = 13
        static let contentTopPadding: CGFloat = 8
        static let contentBottomPadding: CGFloat = 12
        static let contentSpacing: CGFloat = 8
        static let cornerRadius: CGFloat = 10
        static let borderWidth: CGFloat = 1
        static let shadowRadius: CGFloat = 2
        static let shadowOffsetY: CGFloat = 1
        static let addButtonSize: CGFloat = 24
        static let tagHeight: CGFloat = 26
        static let tagHorizontalPadding: CGFloat = 6
    }
    
    // MARK: - Properties
    let imageURL: String
    let name: String
    let price: String
    let tagText: String? 
    let onAdd: () -> Void
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                CachedAsyncImage(url: URL(string: imageURL), height: Layout.imageHeight)

                if let tagText {
   //                 TagView(text: tagText)
   //                     .padding(.top, Layout.tagTopPadding)
   //                     .padding(.leading, Layout.tagLeadingPadding)
                }
            }
            
            VStack(alignment: .leading, spacing: Layout.contentSpacing) {
                Text(name)
                    .font(DS.Typography.body2())
                    .foregroundColor(DS.Colors.neutral900)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3) // permite até 2 linhas (ou remova o argumento pra ilimitado)
                
                Spacer()
                
                HStack {
                    Text(price)
                        .font(DS.Typography.title3())
                        .foregroundColor(DS.Colors.blueBase)
                    
                    Spacer()
                    
                    addButton
                }
            }
            .padding(.horizontal, Layout.contentHorizontalPadding)
            .padding(.top, Layout.contentTopPadding)
            .padding(.bottom, Layout.contentBottomPadding)
        }
        .frame(width: Layout.width, height: Layout.height)
        .background(DS.Colors.white)
        .cornerRadius(Layout.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: Layout.cornerRadius)
                .stroke(DS.Colors.neutral300, lineWidth: Layout.borderWidth)
        )
        .shadow(color: DS.Colors.shadowXS2,
                radius: Layout.shadowRadius,
                x: 0,
                y: Layout.shadowOffsetY)
    }
    
    // MARK: - Add Button
    private var addButton: some View {
        Button(action: onAdd) {
            Image(systemName: "plus")
                .font(DS.Typography.caption())
                .foregroundColor(DS.Colors.white)
                .frame(width: Layout.addButtonSize, height: Layout.addButtonSize)
                .background(DS.Colors.blueBase)
                .clipShape(Circle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TagView: View {
    enum Layout {
        static let height: CGFloat = 26
        static let horizontalPadding: CGFloat = 6
        static let cornerRadius: CGFloat = 9999
    }
    
    let text: String
    
    var body: some View {
        Text(text)
            .font(DS.Typography.caption())
            .foregroundColor(DS.Colors.white)
            .padding(.horizontal, Layout.horizontalPadding)
            .frame(height: Layout.height)
            .background(DS.Colors.redBase)
            .cornerRadius(Layout.cornerRadius)
    }
}


#Preview {
    ProductItemView(imageURL: "heart", name: "Kit Panelas Antiaderente Cerâmica", price: "R$ 599,00", tagText: "20 off", onAdd: {})
}


