import SwiftUI

struct ActionSheetHeader: View {
    struct Buttons {
        static var left = 0
        static var right = 1
    }

    var title: String = ""
    var subTitle: String = ""
    var leftButtonText: String = ""
    var leftButtonSystemImage: String = ""
    var leftAccessability: Accessability = .closeDialogButton
    var rightButtonText: String = ""
    var rightButtonSystemImage: String = ""
    var rightAccessability: Accessability = .editEntryButton
    var onButtonPressed: (Int) -> () = { _ in }

    let iconFont: Font = Font.headline.weight(.bold)

    var body: some View {
        ZStack {
            VStack {
                if self.title != "" {
                    Text(self.title).font(.headline).lineLimit(1)
                }

                if self.subTitle != "" {
                    Text(self.subTitle).font(.caption).lineLimit(1)
                }
            }
            .padding(.vertical)
            .foregroundColor(.highlight)

            HStack(alignment: .center) {
                Button(action: {
                    self.onButtonPressed(Buttons.left)

                }) {
                    if leftButtonSystemImage != "" {
                        Image(systemName: leftButtonSystemImage).font(iconFont)
                    }
                    Text(leftButtonText)
                }
                .foregroundColor(.action)
                .setAccessability(leftAccessability)

                Spacer()

                Button(action: {
                    self.onButtonPressed(Buttons.right)

                }) {
                    if rightButtonSystemImage != "" {
                        Image(systemName: rightButtonSystemImage).font(iconFont)
                    }
                    Text(rightButtonText)
                }
                .foregroundColor(.action)
                .setAccessability(rightAccessability)
            }
            .padding()
            .foregroundColor(.actionInvers)
        }
        .background(Color.actionBarBackground)
        .frame(height: 52)
    }
}
