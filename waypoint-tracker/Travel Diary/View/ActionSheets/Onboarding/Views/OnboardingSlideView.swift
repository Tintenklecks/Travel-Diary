import SwiftUI
import UIKit

struct OnboardingSlideView: View {
    var title: String
    var titleColor: Color = .white
    var slide: OnboardingSlideViewModel

    let imageWidth: CGFloat = 200
    let textWidth: CGFloat = UIScreen.main.bounds.size.width * 4 / 5

    let font = (UIScreen.main.bounds.size.width / UIScreen.main.bounds.size.height) < 0.5 ?
        Font.system(.body, design: .rounded) : // iPhone x screen models
        Font.system(size: 15, weight: .regular, design: .rounded)

    var body: some View {
        VStack(alignment: .center, spacing: 36) {
            Text(title)
                .font(Font.system(.largeTitle, design: .rounded))
                .foregroundColor(slide.titleColor)
                .frame(width: textWidth)
                .multilineTextAlignment(.center)
            slide.image
                .resizable()
                .scaledToFill()
                .frame(width: imageWidth, height: imageWidth)
                .cornerRadius(12)
                .clipped()
                .modifier(OBInsetShadow())
            VStack(alignment: .center, spacing: 5) {
                Text(slide.title)
                    .frame(width: textWidth)
                    .font(Font.system(.headline, design: .rounded))
                    .foregroundColor(slide.titleColor)
                    .layoutPriority(199)
                    .multilineTextAlignment(.center)
                Text(slide.text)
                    .frame(width: textWidth)
                    .layoutPriority(200)
                    .font(.subheadline)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(slide.textColor)
                    .multilineTextAlignment(.center)
            }
            Color.clear.frame(width: 10, height: 40)
        }
    }
}

struct OBInsetShadow: ViewModifier {
    var size: CGFloat = 1
    var radius: CGFloat = 1
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.2),
                    radius: self.radius / 2,
                    x: self.size * 1, y: self.size * 1.5)
            .shadow(color: Color.white,
                    radius: self.radius,
                    x: -self.size, y: -self.size)
    }
}

struct OnboardingSlideView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.red.edgesIgnoringSafeArea(.all)
            Image("obTracking1").cornerRadius(8).frame(width: 250, height: 250)
                .modifier(OBInsetShadow(size: 1, radius: 1))
        }
    }
}

