//
//  DesignSystem.swift
//  OrderFlowWhiteLabel
//
//  Created by Mirelle Alves Sine on 09/10/25.
//

import Foundation

import SwiftUI

// MARK: - Design Tokens

enum DS {
    enum Colors {
        // Hex originais com alpha FF
        static let neutral900 = Color(red: 0x17/255, green: 0x1A/255, blue: 0x1F/255) // #171A1F
        static let white      = Color.white
        static let blueBase   = Color(red: 0x37/255, green: 0x6F/255, blue: 0xC8/255) // #376FC8
        static let blueHover  = Color(red: 0x24/255, green: 0x49/255, blue: 0x84/255) // #244984
        static let bluePress  = Color(red: 0x17/255, green: 0x2F/255, blue: 0x55/255) // #172F55
        // Sombras (aprox. do CSS)
        static let shadowXS1  = Color.black.opacity(0.82) // 0x171a1fD ≈ 82%
        static let shadowXS2  = Color.black.opacity(0.08) // 0x171a1f14 ≈ 8%
    }

    enum Radius {
        static let sm: CGFloat = 6
    }

    enum Spacing {
        static let insetX: CGFloat = 12
        static let buttonHeight: CGFloat = 48
        static let pageLeading: CGFloat = 16
    }

    enum Typography {
        /// Título (Roboto Bold 30/36). Usa Dynamic Type e fallback caso Roboto não esteja disponível.
        static func title() -> Font {
            if UIFont.familyNames.contains(where: { $0.localizedCaseInsensitiveContains("Roboto") }) {
                return .custom("Roboto-Bold", size: 30, relativeTo: .title2) // line-height ~36 em iOS é via spacing automático
            } else {
                return .system(size: 30, weight: .bold, design: .default)
            }
        }

        /// Body/Buttons (Roboto Medium 18/28). Usa Dynamic Type.
        static func button() -> Font {
            if UIFont.familyNames.contains(where: { $0.localizedCaseInsensitiveContains("Roboto") }) {
                return .custom("Roboto-Medium", size: 18, relativeTo: .headline)
            } else {
                return .system(.headline, design: .default)
            }
        }
    }

    enum Shadow {
        /// Aproximação do "shadow-xs" do CSS: 0 0 1px e 0 0 2px combinados.
        static func xs() -> some View {
            // Duas camadas para simular os dois box-shadows
            EmptyView()
                .shadow(color: Colors.shadowXS1, radius: 1, x: 0, y: 0)
                .shadow(color: Colors.shadowXS2, radius: 2, x: 0, y: 0)
        }
    }
}

// MARK: - Title Text (Componente)

struct TitleText: View {
    let text: String

    var body: some View {
        Text(text)
            .font(DS.Typography.title())
            .foregroundStyle(DS.Colors.neutral900)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, DS.Spacing.pageLeading)
            .padding(.top, 0) // mantém top = 0 da sua spec (layout cuida do resto)
            .accessibilityAddTraits(.isHeader)
    }
}

// MARK: - Primary Button Style

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    @State private var isHovering: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        let base = DS.Colors.blueBase
        let hover = DS.Colors.blueHover
        let press = DS.Colors.bluePress

        let bg: Color = {
            if !isEnabled { return base.opacity(0.4) }
            if configuration.isPressed { return press }
            // Em iPadOS/macOS, refletir hover; em iPhone não muda
            return isHovering ? hover : base
        }()

        return configuration.label
            .font(DS.Typography.button())
            .foregroundStyle(DS.Colors.white)
            .frame(maxWidth: .infinity, minHeight: DS.Spacing.buttonHeight)
            .contentShape(RoundedRectangle(cornerRadius: DS.Radius.sm, style: .continuous))
            .background(
                RoundedRectangle(cornerRadius: DS.Radius.sm, style: .continuous)
                    .fill(bg)
            )
            .overlay(
                // Sombra XS
                RoundedRectangle(cornerRadius: DS.Radius.sm, style: .continuous)
                    .fill(.clear)
                    .background(DS.Shadow.xs())
            )
            .padding(.horizontal, DS.Spacing.pageLeading)
            .onHover { hovering in
                // Só tem efeito em iPad com trackpad/macOS; em iOS touch não muda
                self.isHovering = hovering
            }
            .animation(.easeOut(duration: 0.15), value: isHovering)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
            .accessibilityHint(isEnabled ? "Botão primário" : "Botão desativado")
    }
}

// MARK: - Primary Button (Convenience)

struct PrimaryButton: View {
    let title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .buttonStyle(PrimaryButtonStyle())
    }
}

// MARK: - Exemplo de Tela (usa posições da sua spec)

struct SpecExampleView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Texto no topo, alinhado à esquerda com 16pt
            TitleText(text: "Título")

            // Botão a 524pt do topo, alinhado à esquerda com 16pt e largura máxima
            VStack { Spacer().frame(height: 524) }
            PrimaryButton(title: "Continuar") {
                print("Tapped")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .ignoresSafeArea(edges: .bottom) // opcional
    }
}

// MARK: - Previews

#Preview {
    VStack(spacing: 24) {
        TitleText(text: "Título")

        PrimaryButton(title: "Continuar") { }

        PrimaryButton(title: "Desabilitado") { }
            .disabled(true)
    }
    .padding()
}
