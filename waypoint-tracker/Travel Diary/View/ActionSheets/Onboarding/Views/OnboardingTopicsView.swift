//
//  OnboardingTopicsView.swift
//  Onboarding
//
//  Created by Ingo Böhme on 16.07.20.
//  Copyright © 2020 Ingo Böhme. All rights reserved.
//

import SwiftUI

struct OnboardingTopicsView: View {
    @EnvironmentObject var viewModel: OnboardingViewModel
    @Binding var id: String

    private let iconWidth = CGFloat(48)
    @State private var alwaysDisplay = true // FIXME: Settings.alwaysDisplay
    /// The main view with all topics

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()

            HStack(alignment: .top) {
                Color.clear
                    .frame(width: iconWidth, height: 1)
                    .padding(.trailing, 16)
                Text(self.viewModel.title)
                    .font(Font.system(size: 38, weight: .bold, design: .rounded))
                    .foregroundColor(self.viewModel.color.title)
            }
            ForEach(self.viewModel.topics) { topic in
                HStack(alignment: .top) {
                    topic.icon
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: self.iconWidth, height: self.iconWidth).padding(.trailing, 16)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(topic.title)
                            .font(.headline)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(self.viewModel.color.title)
                        Text(topic.text)
                            .font(.subheadline)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(self.viewModel.color.text)
                    }
                }
                .padding(.top, 10)
                .onTapGesture {
                    self.id = topic.id
                }
            }
            Spacer()
            HStack {
                Spacer()
                Image(self.alwaysDisplay ? "checkbox1" : "checkbox0").renderingMode(.original)

                Text("Always display this intro screen on app start")
                    .font(.footnote)
                    .foregroundColor(Color.black.opacity(0.6))
                Spacer()
            }.onTapGesture {
                self.alwaysDisplay.toggle()
                Settings.showWhatsNew = self.alwaysDisplay
            }
        }
    }
}

struct AllFontStyles_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("large title").font(.largeTitle)
            Text("title").font(.title)
            Text("headline").font(.headline)
            Text("subheadline").font(.subheadline)
            Text("body").font(.body)
            Text("footnote").font(.footnote)
            Text("callout").font(.callout)
            Text("caption").font(.caption)
        }
    }
}
