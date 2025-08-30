//

import SwiftUI

struct LaunchView: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var diary: DiaryViewModel

    @State private var subtitleAlpha: Double = 0
    @State private var titleText: String = "" {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.nextCharacter()
            }
        }
    }

    @State private var subTitleText:
        String = TXT.launchViewSubtitle

    @State private var displayText: String = TXT.launchViewTitle

    func nextCharacter() {
        if let c = displayText.first {
            titleText = titleText + String(c)
            displayText = String(displayText.dropFirst())
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if Fastlane.isScreenshotMode == false {
                    self.settings.startAnimationDone = true
                }
            }
        }
    }

    let cursor = "|"
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                WorldAnimation()
                    .frame(width: proxy.size.width * 0.5)

                HStack {
                    Text(self.titleText)
                        .multilineTextAlignment(.center)
                    if self.displayText != "" {
                        Text(self.cursor)
                            .foregroundColor(.black)
                    }
                }
                .foregroundColor(.highlight)
                .font(Font.custom("AmericanTypewriter", size: 36))
                .offset(y: -0.25 * proxy.size.height)
                .padding(.horizontal, 32)

                Text(self.subTitleText)
                    .font(.subheadline).fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .offset(y: 0.25 * proxy.size.height)
                    .opacity(self.subtitleAlpha)

                // FASTLANE 
                if Fastlane.isScreenshotMode {
                    VStack {
                        Spacer()
                        Button(action: {
                            self.settings.startAnimationDone = true

                        }) {
                            Text("Start").foregroundColor(.clear)
                        }
                    }.onAppear {
                        // Location
                        _ = LocationPublisher.shared

                        // Photo Roll
                        UIImage.photorollCount(inRange: Date(), endDate: Date()) { count in
                            //print(count)
                        }

                        // Notification
                        UNUserNotificationCenter.current().requestAuthorization(options: [.badge]) {
                            _, _ in
                        }
                    }
                }
            }
            .onAppear() {
                self.nextCharacter()
            }
        }
        .background(Color.neoWhite.edgesIgnoringSafeArea(.all))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                withAnimation(Animation.easeOut(duration: 1)) {
                    self.subtitleAlpha = 1
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.diary.status = .loaded
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
