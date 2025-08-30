import SwiftUI

//struct NeoView<Content>: View where Content: View {
//    var cornerRadius: CGFloat = 8
//    var color = Color(red: 0.9, green: 0.9, blue: 0.9)
//    var shadowUpLeft = Color.white
//    var shadowDownRight = Color.black.opacity(0.4)
//    var intensity: CGFloat = 0.5
//    let content: () -> Content
//
//    var body: some View {
//        VStack {
//            ZStack {
//                content()
//            }
//            .background(
//                color
//                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
//
//                    .shadow(color: shadowDownRight, radius: intensity, x: intensity, y: intensity)
//                    .shadow(color: shadowUpLeft, radius: intensity, x: -intensity, y: -intensity)
//            )
//        }
//    }
//}
//
