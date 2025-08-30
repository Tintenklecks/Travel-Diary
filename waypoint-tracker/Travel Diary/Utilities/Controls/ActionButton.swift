//

import SwiftUI

struct ActionButtonNew: View {
    var image: Image = Image("nada")
    var caption: String = ""
    let closure: () -> ()

    var body: some View {
        Button(action: {
            self.closure()
        }) {
            HStack {
                image
                if self.caption != "" {
                    Text(caption)
                }
            }
            .padding([.leading, .trailing], 16)
            .padding([.top, .bottom], 8)
            .background(Color.action)
            .foregroundColor(Color.actionInvers)
            .clipShape(Capsule())
            .clipped()
            .modifier(NeoStyleModifier())
        }
    }
}

struct ActionButton: View {
    var image: Image = Image("nada")
    var depth: CGFloat = 1
    var caption: String = ""
    let closure: () -> ()

    var body: some View {
        Button(action: {
            self.closure()
        }) {
            HStack {
                image
                if self.caption != "" {
                    Text(caption)
                }
            }
        }
        .buttonStyle(CapsuleStyleFilled(depth: depth))
    }
}

struct ActionButtonRoundNew: View {
    var image: Image = Image("nada")
    let closure: () -> ()

    var body: some View {
        HStack {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
        }
        .padding(10)
        .background(Color.action)
        .foregroundColor(Color.actionInvers)
        .clipShape(Circle())
        .clipped()
        .modifier(NeoStyleModifier())
        .onTapGesture {
            self.closure()
        }
    }
}

struct ActionButtonRound: View {
    var image: Image = Image("nada")
    var depth: CGFloat = 1
   let closure: () -> ()

    var body: some View {
        Button(action: { self.closure() }) {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
        }
        .buttonStyle(CapsuleStyleFilled(circle: true, depth: depth))
    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.neoWhite
            VStack {
                ActionButtonRound(image: Image(systemName: "gear")) {}
                Divider()

                ActionButtonRoundNew(image: Image(systemName: "gear")) {}
                Divider()

                ActionButton(image: Image(systemName: "gear"), caption: "Settings") {
                    print("Go To Settings")
                }
                Divider()
                ActionButtonNew(image: Image(systemName: "gear"), caption: "Settings") {
                    print("Go To Settings")
                }
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct CapsuleStyleFilled: ButtonStyle {
    var circle = false
    var isSelected = false
    var depth: CGFloat = 4
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.horizontal, circle ? 8 : 12)
            .padding(.vertical,  circle ? 8 : 6)
            .background(LinearGradient(gradient: Gradient(colors:
                self.isSelected ? [Color.action, Color.actionLight] : [Color.neoWhite, Color.neoWhite, Color.neoWhiteLight]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(22)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .modifier(NeoStyleModifier(size: configuration.isPressed ? 0 : depth))
            .offset(x: configuration.isPressed ? depth / 2 : 0, y: configuration.isPressed ? depth / 2 : 0)
            .foregroundColor(self.isSelected ? .actionInvers : .action)
    }
}
