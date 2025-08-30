
import SwiftUI

struct TabBarItemView: View {
    @Binding var selectedItem: TabBarViews
    
    let uuid = UUID()
    var smartView: TabBarViews
    var icon: String
    
    let size: CGFloat = 32
    func isSelected() -> Bool {
        return selectedItem == smartView
    }
    
    var body: some View {
        Button(action: {
            self.selectedItem = self.smartView
        }) {
            if isSelected() {
                buttonDown
            } else {
                buttonUp
            }
        }
    }
    
    var buttonUp: some View {
        var buttonMask: some View {
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: size * 2, height: size * 2)
                Image(systemName: self.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            }
        }
        
        var button: some View {
            ZStack {
                LinearGradient.lairHorizontalDarkReverse
                    .frame(width: size, height: size)
                Rectangle()
                    .inverseMask(buttonMask)
                    .frame(width: size * 2, height: size * 2)
                    .foregroundColor(.lairBackgroundGray)
                    .shadow(color: .lairShadowGray, radius: 3, x: 3, y: 3)
                    .shadow(color: .white, radius: 3, x: -3, y: -3)
                    .clipShape(RoundedRectangle(cornerRadius: size * 8 / 16))
            }
            .compositingGroup()
            .shadow(color: Color.white.opacity(0.9), radius: 10, x: -5, y: -5)
            .shadow(color: Color.lairShadowGray.opacity(0.5), radius: 10, x: 5, y: 5)
        }
        
        return button
    }
    
    var buttonDown: some View {
        var buttonMask: some View {
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: size * 2, height: size * 2)
                Image(systemName: self.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            }
        }
        
        var button: some View {
            ZStack {
//                LinearGradient.lairHorizontalDarkReverse
                //                  .frame(width: size, height: size)
//                Color.red
//                    .frame(width: size, height: size)
                Rectangle()
//                    .inverseMask(buttonMask)
                    .frame(width: size * 2, height: size * 2)
                    .foregroundColor(.neoWhite)
//                    .shadow(color: .lairShadowGray, radius: 1, x: 0, y: 0)
//                    .shadow(color: .white, radius: 1, x: 0, y: 0)
                    .clipShape(RoundedRectangle(cornerRadius: size * 8 / 16))
                Image(systemName: self.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    .foregroundColor(Color.actionBackColor)
            }
            .compositingGroup()
            .shadow(color: Color.white.opacity(0.9), radius: 2, x: -1, y: 1)
            .shadow(color: Color.lairShadowGray.opacity(0.5), radius: 2, x: 1, y: 1)
            .offset(x: 2, y: 2)
            .scaleEffect(0.9)
        }
        
        return button
    }
    
    var buttonDownxxx: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.lairBackgroundGray)
                .frame(width: size * 2.25, height: size * 2.25)
                .cornerRadius(size * 8 / 16)
                
                .shadow(
                    color: Color.lairShadowGray.opacity(0.7),
                    radius: size * 0.1875,
                    x: size * 0.1875, y: size * 0.1875)
                .shadow(
                    color: Color(white: 1.0).opacity(0.9),
                    radius: size * 0.1875,
                    x: -size * 0.1875, y: -size * 0.1875)
                .clipShape(RoundedRectangle(cornerRadius: size * 8 / 16))
                .opacity(0.3)
            LinearGradient.lairHorizontalDarkReverse // Image
                .frame(width: size, height: size)
                .mask(Image(systemName: self.icon)
                    .resizable()
                    .scaledToFit()
                )
                .shadow(
                    color: Color.lairShadowGray.opacity(0.5),
                    radius: size * 0.1875,
                    x: size * 0.1875, y: size * 0.1875)
                .shadow(
                    color: Color(white: 1.0).opacity(0.9),
                    radius: size * 0.1875,
                    x: -size * 0.1875, y: -size * 0.1875)
        }
        .shadow(color: Color.white.opacity(0.9), radius: 10, x: -5, y: -5)
        .shadow(color: Color.lairShadowGray.opacity(0.5), radius: 10, x: 5, y: 5)
//        .overlay(
//            RoundedRectangle(cornerRadius: size * 8 / 16)
//                .stroke(LinearGradient.lairDiagonalLightBorder, lineWidth: 2)
//        )
    }
}

struct TabBarItemView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarItemView(
            selectedItem: .constant(TabBarViews.waypoints),
            smartView: .waypoints, icon: "pencil.tip")
    }
}
