import SwiftUI

struct XXX: View {
    
    
    let textButtons = (0..<MockData.iconAndTextTitles.count).reversed().map { i in
        AnyView(IconAndTextButton(imageName: MockData.iconAndTextImageNames[i], buttonText: MockData.iconAndTextTitles[i]))
    }

    let mainButton1 = AnyView(MainButton(imageName: "star.fill", colorHex: "f7b731", width: 60))
    let mainButton2 = AnyView(MainButton(imageName: "heart.fill", colorHex: "eb3b5a", width: 60))

    

    var body: some View {
        FloatingButton(mainButtonView: mainButton1, buttons: textButtons)
            .straight()
            .direction(.top)
            .alignment(.left)
            .spacing(10)
            .initialOffset(x: -1000)
            .animation(.spring())


    }
}

struct MainButton: View {

    var imageName: String
    var colorHex: String

    var width: CGFloat = 50

    var body: some View {
        ZStack {
            Color(hex: colorHex)
                .frame(width: width, height: width)
                .cornerRadius(width/2)
                .shadow(color: Color(hex: colorHex).opacity(0.3), radius: 15, x: 0, y: 15)
            Image(systemName: imageName).foregroundColor(.white)
        }.border(Color.red, width: 1)
    }
}

struct IconButton: View {

    var imageName: String
    var color: Color

    let imageWidth: CGFloat = 20
    let buttonWidth: CGFloat = 45

    var body: some View {
        ZStack {
            self.color

            Image(systemName: imageName)
                .frame(width: self.imageWidth, height: self.imageWidth)
                .foregroundColor(.white)
        }
        .frame(width: self.buttonWidth, height: self.buttonWidth)
        .cornerRadius(self.buttonWidth / 2)
    }
}

struct IconAndTextButton: View {

    var imageName: String
    var buttonText: String

    let imageWidth: CGFloat = 22

    var body: some View {
        ZStack {
            Color.white

            HStack {
                Image(systemName: self.imageName)
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .foregroundColor(Color(hex: "778ca3"))
                    .frame(width: self.imageWidth, height: self.imageWidth)
                    .clipped()
                Spacer()
                Text(buttonText)
                    .font(.system(size: 16, weight: .semibold, design: .default))
                    .foregroundColor(Color(hex: "4b6584"))
                Spacer()
            }.padding(.leading, 15).padding(.trailing, 15)
        }
        .frame(width: 160, height: 45)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 1)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: "F4F4F4"), lineWidth: 1)
        )
    }
}

struct MockData {

    static let colors = [
        "e84393",
        "0984e3",
        "6c5ce7",
        "00b894"
    ].map { Color(hex: $0) }

    static let iconImageNames = [
        "sun.max.fill",
        "cloud.fill",
        "cloud.rain.fill",
        "cloud.snow.fill"
    ]

    static let iconAndTextImageNames = [
        "plus.circle.fill",
        "minus.circle.fill",
        "pencil.circle.fill"
    ]

    static let iconAndTextTitles = [
        "Add New",
        "Remove",
        "Rename"
    ]
}

extension Color {
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff

        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
    
}
