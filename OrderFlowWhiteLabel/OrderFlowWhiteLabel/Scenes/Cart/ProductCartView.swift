import SwiftUI

struct ProductCartItemView: View {
    // MARK: - Layout Constants
    enum Layout {
        static let width: CGFloat = 358
        static let cornerRadius: CGFloat = 10
        static let borderWidth: CGFloat = 1
        static let padding: CGFloat = 16
        static let imageSize: CGFloat = 74
        static let spacing: CGFloat = 16
        static let controlsWidth: CGFloat = 110
        static let buttonSize: CGFloat = 32
        static let verticalSpacing: CGFloat = 12
    }

    // MARK: - Properties
    let title: String
    let imageURL: String
    let unitPrice: Double
    var minQuantity = 1
    var maxQuantity = 99

    @Binding var quantity: Int
    let onIncrease: () -> Void
    let onDecrease: () -> Void

    private var totalPrice: Double { unitPrice * Double(quantity) }

    // MARK: - Body
    var body: some View {
        VStack(spacing: Layout.verticalSpacing) {
            Text(title)
                .font(DS.Typography.body2())
                .foregroundColor(DS.Colors.neutral900)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, Layout.padding)
            
            HStack(alignment: .center, spacing: Layout.spacing) {
                CachedAsyncImage(url: URL(string: imageURL), height: Layout.imageSize)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .frame(width: Layout.imageSize, height: Layout.imageSize)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("R$ \(totalPrice, specifier: "%.2f")")
                        .font(DS.Typography.title3())
                        .foregroundColor(DS.Colors.neutral900)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    Text("Unidade: \(unitPrice, specifier: "%.2f")")
                        .font(DS.Typography.caption())
                        .foregroundColor(DS.Colors.neutral700)
                        .minimumScaleFactor(0.8)
                }

                Spacer()

                QuantityControl(
                    quantity: $quantity,
                    min: minQuantity,
                    max: maxQuantity,
                    buttonSize: Layout.buttonSize,
                    onIncrease: onIncrease,
                    onDecrease: onDecrease
                )
                .frame(width: Layout.controlsWidth)
            }
            .padding(.horizontal, Layout.padding)
            .padding(.bottom, Layout.padding)
        }
        .frame(width: Layout.width)
        .background(DS.Colors.white)
        .overlay(
            RoundedRectangle(cornerRadius: Layout.cornerRadius)
                .stroke(DS.Colors.neutral300, lineWidth: Layout.borderWidth)
        )
        .cornerRadius(Layout.cornerRadius)
        .shadow(color: DS.Colors.shadowXS2, radius: 2, x: 0, y: 1)
    }
}

// MARK: - Quantity Control
private struct QuantityControl: View {
    @Binding var quantity: Int
    let min: Int
    let max: Int
    let buttonSize: CGFloat
    let onIncrease: () -> Void
    let onDecrease: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Button {
                guard quantity > min else { return }
                withAnimation(.easeInOut(duration: 0.12)) {
                    onDecrease()
                }
            } label: {
                Image(systemName: "minus")
                    .font(.system(size: 14, weight: .bold))
                    .frame(width: buttonSize, height: buttonSize)
                    .background(DS.Colors.white)
                    .overlay(
                        Circle()
                            .stroke(DS.Colors.neutral300, lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)
            Text("\(quantity)")
                .font(DS.Typography.body2())
                .foregroundColor(DS.Colors.neutral900)
                .frame(minWidth: 30)

            Button {
                guard quantity < max else { return }
                withAnimation(.easeInOut(duration: 0.12)) {
                    onIncrease()
                }
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .bold))
                    .frame(width: buttonSize, height: buttonSize)
                    .background(DS.Colors.blueBase)
                    .foregroundColor(DS.Colors.white)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Preview
#Preview {
    @State var quantity = 1
    ProductCartItemView(
        title: "Camiseta Dry Fit Esportiva",
        imageURL: "https://picsum.photos/200",
        unitPrice: 149.99,
        quantity: $quantity,
        onIncrease: { print("Aumentou!") },
        onDecrease: { print("Diminuiu!") }
    )
    .padding()
    .background(DS.Colors.neutral300.opacity(0.05))
    .previewLayout(.sizeThatFits)
}
