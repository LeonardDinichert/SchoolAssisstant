import SwiftUI

struct AppTheme {
    /// Main brand color inspired by Airbnb's distinctive pink
    static let primaryColor = Color(hex: "#FF385C")
    /// 10% lighter tint of the primary color
    static let primaryTint = Color(hex: "#FF4C6C")
    /// 10% darker shade of the primary color
    static let primaryShade = Color(hex: "#E53253")

    /// Neutral backgrounds
    static let background = Color(light: .white, dark: .black)
    static let cardBackground = Color(light: Color(hex: "#F7F7F7"),
                                      dark: Color(hex: "#1C1C1E"))

    static let cornerRadius: CGFloat = 10

    struct CardModifier: ViewModifier {
        func body(content: Content) -> some View {
            content
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                        .fill(AppTheme.cardBackground)
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
                        .fill(disabled ? AppTheme.primaryShade.opacity(0.5) : AppTheme.primaryColor)
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

extension Color {
    /// Create a color from a hex string like "#FFAA00"
    init(hex: String) {
        var hexString = hex
        if hexString.hasPrefix("#") { hexString.removeFirst() }
        var int: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }

    /// Convenience initializer for dynamic light/dark colors
    init(light: Color, dark: Color) {
        self = Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
}
