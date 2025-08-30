// //  Neomorph
////
// //  Copyright © 2020 Ingo Böhme. All rights reserved.
// import Foundation
//import SwiftUI
//class NeoSettings {
//    static var shadowRadius: CGFloat = 2
//    static var pressedFactor: CGFloat = 0.2
//
//    static func inset(_ pressed: Bool) -> CGFloat { return pressed ? shadowRadius * pressedFactor : shadowRadius }
//    static func offset(_ pressed: Bool) -> CGFloat { return pressed ? shadowRadius * pressedFactor : 0 }
//
//    static var neoWhite = Color.neoWhite
//}
//
//struct NeomorphicModifier: ViewModifier {
//    let pressed: Bool
//
//    func body(content: Content) -> some View {
//        content
////            .shadow(color: Color.black.opacity(0.2), radius: NeoSettings.shadowRadius, x: NeoSettings.inset(pressed), y: NeoSettings.inset(pressed))
////            .shadow(color: Color.white.opacity(0.7), radius: NeoSettings.shadowRadius, x: -NeoSettings.inset(pressed), y: -NeoSettings.inset(pressed))
//            .shadow(color: Color.black.opacity(0.7), radius: NeoSettings.shadowRadius, x: NeoSettings.inset(pressed), y: NeoSettings.inset(pressed))
//            .shadow(color: Color.white.opacity(0.2), radius: NeoSettings.shadowRadius, x: -NeoSettings.inset(pressed), y: -NeoSettings.inset(pressed))
//            .onAppear {}
//    }
//}
//
//extension View {
//    func neoMorphicView(pressed: Bool = false) -> some View {
//        modifier(NeomorphicModifier(pressed: pressed))
//    }
//}
//
////struct NeomorphicRectangle<Content>: View where Content: View {
////    let content: () -> Content
////    let cornerRadius: CGFloat
////
////    init(cornerRadius: CGFloat = 12, content: @escaping () -> Content) {
////        self.cornerRadius = cornerRadius
////        self.content = content
////    }
////
////    var body: some View {
////        VStack {
////            content()
////        }
////        .overlay(
////            RoundedRectangle(cornerRadius: 15)
////                .stroke(LinearGradient.lairDiagonalDarkBorder, lineWidth: 2)
////        )
////        .background(Color.neoWhite)
////        .cornerRadius(15)
////        .shadow(color: Color.lairWhite.opacity(0.9), radius: 18, x: -18, y: -18)
////        .shadow(color: Color.lairShadowGray.opacity(0.5), radius: 14, x: 14, y: 14)
////    }
////}
//
//struct NeomorphicTappableRectangle<Content>: View where Content: View {
//    let content: () -> Content
//    let pressed: Binding<Bool>
//    let cornerRadius: CGFloat
//
//    init(cornerRadius: CGFloat = 12, pressed: Binding<Bool> = .constant(false), content: @escaping () -> Content) {
//        self.pressed = pressed
//        self.cornerRadius = cornerRadius
//        self.content = content
//    }
//
//    var body: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: cornerRadius)
//                .foregroundColor(NeoSettings.neoWhite)
//                .neoMorphicView(pressed: pressed.wrappedValue)
//            content()
//        }
//        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
//        //     .foregroundColor(NeoSettings.neoWhite)
//        .clipped()
//        // ***...
//        .neoMorphicView(pressed: pressed.wrappedValue)
//
//        .onTapGesture {
//            self.pressed.wrappedValue.toggle()
//        }
//
//        .offset(x: NeoSettings.offset(pressed.wrappedValue), y: NeoSettings.offset(pressed.wrappedValue))
//    }
//}
//
//struct NeomorphicCircle<Content>: View where Content: View {
//    let content: () -> Content
//    let pressed: Binding<Bool>
//
//    init(pressed: Binding<Bool> = .constant(false), content: @escaping () -> Content) {
//        self.pressed = pressed
//        self.content = content
//    }
//
//    var body: some View {
//        ZStack {
//            Circle()
//                .foregroundColor(NeoSettings.neoWhite)
//                .neoMorphicView(pressed: self.pressed.wrappedValue)
//            content()
//        }
//        .onTapGesture {
//            self.pressed.wrappedValue.toggle()
//        }
//        .offset(x: NeoSettings.offset(pressed.wrappedValue), y: NeoSettings.offset(pressed.wrappedValue))
//    }
//}
//
//struct CheckmarkView: View {
//    enum Shape {
//        case circle
//        case square
//        case roundedSquare
//    }
//
//    let checked: Binding<Bool>
//    let diameter: CGFloat
//    let systemImage: String
//    let shape: CheckmarkView.Shape
//
//    init(pressed: Binding<Bool> = .constant(false), diameter: CGFloat = 16,
//         systemImage: String = "checkmark",
//         shape: CheckmarkView.Shape = .circle) {
//        self.checked = pressed
//        self.diameter = diameter
//        self.systemImage = systemImage
//        self.shape = shape
//    }
//
//    private var statusImage: some View {
//        Image(systemName: self.systemImage)
//            .resizable()
//            .scaledToFit()
//            .foregroundColor(Color.primary)
//            .opacity(self.checked.wrappedValue ? 0.1 : 0.85)
//            .frame(width: self.diameter, height: self.diameter)
//            .padding(self.diameter / 2)
//    }
//
//    var body: some View {
//        var result = AnyView(Rectangle())
//        switch self.shape {
//        case .circle:
//            result = AnyView(NeomorphicCircle(pressed: self.checked) {
//                self.statusImage
//            })
//        case .square:
//            result = AnyView(NeomorphicTappableRectangle(cornerRadius: 0, pressed: self.checked) {
//                self.statusImage
//            })
//        default:
//            result = AnyView(NeomorphicTappableRectangle(cornerRadius: diameter * 0.1, pressed: self.checked) {
//                self.statusImage
//            })
//        }
//        return result
//            .frame(width: self.diameter, height: self.diameter)
//    }
//}
