import SwiftUI

struct AppTheme {
    static let primaryColor = Color.blue
    static let cornerRadius: CGFloat = 12

    struct CardModifier: ViewModifier {
        func body(content: Content) -> some View {
            content
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                        .fill(Color(uiColor: .secondarySystemBackground))
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                )
        }
    }

    struct PrimaryButtonModifier: ViewModifier {
        var disabled: Bool
        func body(content: Content) -> some View {
            content
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                        .fill(disabled ? Color.gray : AppTheme.primaryColor)
                )
        }
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(AppTheme.CardModifier())
    }

    func primaryButtonStyle(disabled: Bool = false) -> some View {
        modifier(AppTheme.PrimaryButtonModifier(disabled: disabled))
    }
}
