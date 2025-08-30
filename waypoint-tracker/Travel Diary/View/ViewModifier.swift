import SwiftUI

// MARK: - View Modifiers -

struct TextFieldModifier: ViewModifier {
    var horizontalPadding: CGFloat = 8
    var verticalPadding: CGFloat = 8
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, self.horizontalPadding)
            .padding(.vertical, self.verticalPadding)
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.primary, lineWidth: 0.5))
    }
}

struct TextFieldButtonsModifier: ViewModifier {
    @Binding var text: String
    var showKeyboard: Bool = false
    var showClear: Bool = true
    public func body(content: Content) -> some View {
        ZStack(alignment: .topTrailing) {
            content

            HStack {
                
                
                
                if showClear {
                    if !text.isEmpty {
                        Button(action: {
                            self.text = ""
                        }) {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.action)
                                .setAccessability(.clearTextField)
                        }
                        .padding([.trailing, .top], 16)
                    }
                }
            }
        }
    }
}

struct ClearButtonModifier: ViewModifier {
    @Binding var text: String
    public func body(content: Content) -> some View {
        ZStack(alignment: .topTrailing) {
            content

            if !text.isEmpty {
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.action)
                        .setAccessability(.clearTextField)
                }
                .padding([.top], 16)
                .padding([.trailing], 8)
            }
        }
    }
}


struct NeoStyleModifier: ViewModifier {
    var size: CGFloat = 2
    var background = Color.neoWhite
    var lightShadow = Color.neoLightShadow
    var darkShadow = Color.neoDarkShadow

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 20)

                    .foregroundColor(self.background)
                    .shadow(color: self.lightShadow,
                            radius: self.size,
                            x: -self.size, y: -self.size)
                    .shadow(color: self.darkShadow,
                            radius: self.size,
                            x: self.size, y: self.size)
            )
    }
}

struct HeadlineStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.titleBarHeadline)
            .foregroundColor(.highlight)
    }
}
