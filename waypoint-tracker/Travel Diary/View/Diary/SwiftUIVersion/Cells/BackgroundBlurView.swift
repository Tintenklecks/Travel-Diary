import SwiftUI

struct Blur: UIViewRepresentable {
    var isDarkmode: Bool = false

    var style: UIBlurEffect.Style {
        isDarkmode ? .systemMaterialDark : .systemMaterialLight
    }

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
