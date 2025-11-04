import SwiftUI

enum DS {
    enum Colors {
        static let neutral900 = Color(red: 0x17/255, green: 0x1A/255, blue: 0x1F/255)
        static let white      = Color.white
        static let blueBase   = Color(red: 0x37/255, green: 0x6F/255, blue: 0xC8/255)
        static let blueHover  = Color(red: 0x24/255, green: 0x49/255, blue: 0x84/255)
        static let bluePress  = Color(red: 0x17/255, green: 0x2F/255, blue: 0x55/255)
        static let shadowXS1  = Color.black.opacity(0.82)
        static let shadowXS2  = Color.black.opacity(0.08)
        static let redBase    = Color(red: 0xC4/255, green: 0x4B/255, blue: 0x4B/255)
        static let neutral700 = DS.Colors.neutral900.opacity(0.75)
        static let neutral300 = DS.Colors.neutral900.opacity(0.12)
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
        static func title() -> Font {
            UIFont.familyNames.contains(where: { $0.localizedCaseInsensitiveContains("Roboto") })
            ? .custom("Roboto-Bold", size: 30, relativeTo: .title2)
            : .system(size: 30, weight: .bold)
        }

        static func button() -> Font {
            UIFont.familyNames.contains(where: { $0.localizedCaseInsensitiveContains("Roboto") })
            ? .custom("Roboto-Medium", size: 18, relativeTo: .headline)
            : .system(.headline)
        }

        static func body() -> Font {
            UIFont.familyNames.contains(where: { $0.localizedCaseInsensitiveContains("Roboto") })
            ? .custom("Roboto-Regular", size: 16, relativeTo: .body)
            : .system(.body)
        }

        static func bodySemibold() -> Font {
            UIFont.familyNames.contains(where: { $0.localizedCaseInsensitiveContains("Roboto") })
            ? .custom("Roboto-Medium", size: 16, relativeTo: .body)
            : .system(size: 16, weight: .semibold)
        }

        static func sectionTitle() -> Font {
            UIFont.familyNames.contains(where: { $0.localizedCaseInsensitiveContains("Roboto") })
            ? .custom("Roboto-Medium", size: 18, relativeTo: .headline)
            : .system(size: 18, weight: .semibold)
        }

        static func caption() -> Font {
            UIFont.familyNames.contains(where: { $0.localizedCaseInsensitiveContains("Roboto") })
            ? .custom("Roboto-Regular", size: 14, relativeTo: .caption)
            : .system(.caption)
        }

        static func displaySuccess() -> Font {
            UIFont.familyNames.contains(where: { $0.localizedCaseInsensitiveContains("Roboto") })
            ? .custom("Roboto-Bold", size: 24, relativeTo: .title3)
            : .system(size: 24, weight: .bold)
        }
    }

    enum Shadow {
        static func xs() -> some View {
            EmptyView()
                .shadow(color: Colors.shadowXS1, radius: 1)
                .shadow(color: Colors.shadowXS2, radius: 2)
        }
    }

    enum Border {
        static let hairline: CGFloat = 1
    }
}

// MARK: - Buttons

struct PrimaryButton: View {
    let title: String
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(DS.Typography.button())
                .foregroundStyle(DS.Colors.white)
                .frame(maxWidth: .infinity, minHeight: DS.Spacing.buttonHeight)
                .background(
                    RoundedRectangle(cornerRadius: DS.Radius.sm)
                        .fill(DS.Colors.blueBase)
                )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, DS.Spacing.pageLeading)
    }
}

struct SecondaryButton: View {
    let title: String
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(DS.Typography.button())
                .foregroundStyle(DS.Colors.blueBase)
                .frame(maxWidth: .infinity, minHeight: DS.Spacing.buttonHeight)
                .overlay(
                    RoundedRectangle(cornerRadius: DS.Radius.sm)
                        .stroke(DS.Colors.blueBase, lineWidth: DS.Border.hairline)
                )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, DS.Spacing.pageLeading)
    }
}

struct DangerButton: View {
    let title: String
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(DS.Typography.button())
                .foregroundStyle(DS.Colors.white)
                .frame(maxWidth: .infinity, minHeight: DS.Spacing.buttonHeight)
                .background(
                    RoundedRectangle(cornerRadius: DS.Radius.sm)
                        .fill(DS.Colors.redBase)
                )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, DS.Spacing.pageLeading)
    }
}

// MARK: - Cards & Dividers

struct DSCard<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }
    var body: some View {
        VStack(spacing: 0) { content }
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: DS.Radius.sm)
                    .fill(DS.Colors.white)
                    .background(DS.Shadow.xs())
            )
            .padding(.horizontal, DS.Spacing.pageLeading)
    }
}

struct DSSectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(DS.Typography.sectionTitle())
            .foregroundStyle(DS.Colors.neutral900)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, DS.Spacing.insetX)
            .padding(.bottom, 8)
    }
}

struct DSInsetDivider: View {
    var body: some View {
        Rectangle()
            .fill(DS.Colors.neutral300)
            .frame(height: 1 / UIScreen.main.scale)
            .padding(.horizontal, DS.Spacing.insetX)
    }
}

struct DSDashedDivider: View {
    var body: some View {
        Rectangle()
            .fill(.clear)
            .frame(height: 1)
            .overlay(
                Rectangle()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
                    .foregroundStyle(DS.Colors.neutral300)
            )
            .padding(.horizontal, DS.Spacing.insetX)
            .padding(.top, 4)
    }
}

// MARK: - Icons

struct CircleCheckIcon: View {
    var size: CGFloat = 88
    var body: some View {
        ZStack {
            Circle()
                .stroke(DS.Colors.neutral900, lineWidth: 4)
            Image(systemName: "checkmark")
                .font(.system(size: size * 0.38, weight: .bold))
                .foregroundStyle(DS.Colors.neutral900)
        }
        .frame(width: size, height: size)
    }
}
