//
//  CachedImage.swift
//  OrderFlowWhiteLabel
//
//  Created by João Victor Bernardes Gracês on 03/11/25.
//

import SwiftUI

struct CachedAsyncImage: View {
    let url: URL?
    let height: CGFloat

    @State private var image: Image?
    @State private var isLoading = false

    var body: some View {
        ZStack {
            if let image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: height)
                    .clipped()
            } else if isLoading {
                ProgressView()
                    .frame(height: height)
                    .frame(maxWidth: .infinity)
            } else {
                Color.gray.opacity(0.2)
                    .frame(height: height)
                    .onAppear(perform: load)
            }
        }
    }

    private func load() {
        guard !isLoading, image == nil, let url else { return }
        isLoading = true

        // cache em memória
        if let cached = ImageCache.shared.object(forKey: url.absoluteString as NSString) {
            self.image = Image(uiImage: cached)
            self.isLoading = false
            return
        }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    ImageCache.shared.setObject(uiImage, forKey: url.absoluteString as NSString)
                    await MainActor.run {
                        self.image = Image(uiImage: uiImage)
                    }
                }
            } catch {
                print("Erro ao carregar imagem: \(error)")
            }
            isLoading = false
        }
    }
}

final class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
}
