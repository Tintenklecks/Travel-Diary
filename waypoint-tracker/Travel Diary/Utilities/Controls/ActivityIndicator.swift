 //
  
 import SwiftUI
enum ActivityIndicatorType {
    case spinningCircles
    case rotatingFan
}

struct ActivityIndicator: View {
    @State var type: ActivityIndicatorType = .spinningCircles

    @State private var isAnimating: Bool = false

    var body: some View {
        ZStack {
            if type == .spinningCircles {
                spinningCircles
            } else if type == .rotatingFan {
                rotatingFan
            } else {
                Image(systemName: "circle.grid.hex")
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            self.isAnimating = true
        }

    }

    var spinningCircles: some View {
        GeometryReader { (geometry: GeometryProxy) in
            ForEach(0..<5) { index in
                Group {
                    Circle()
                        .frame(width: geometry.size.width / 5, height: geometry.size.height / 5)
                        .scaleEffect(!self.isAnimating ? 1 - CGFloat(index) / 5 : 0.2 + CGFloat(index) / 5)
                        .offset(y: geometry.size.width / 10 - geometry.size.height / 2)
                }.frame(width: geometry.size.width, height: geometry.size.height)
                    .rotationEffect(!self.isAnimating ? .degrees(0) : .degrees(360))
                    .animation(Animation
                        .timingCurve(0.5, 0.15 + Double(index) / 5, 0.25, 1, duration: 1.5)
                        .repeatForever(autoreverses: false))
            }
        }

    }
    var rotatingFan: some View {
        Image(systemName: "slowmo")
        .resizable()
            .rotationEffect(self.isAnimating ? .degrees(360) : .degrees(0))
            .animation(
                Animation
                    .linear(duration: 1)
                    .repeatForever(autoreverses: false))
            .scaleEffect(self.isAnimating ? 0.5 : 1)
            .animation(
                Animation
                    .linear(duration: 1)
                    .repeatForever(autoreverses: true))
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicator()
    }
}
