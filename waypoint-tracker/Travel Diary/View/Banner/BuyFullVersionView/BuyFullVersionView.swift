//
//  BuyFullVersionView.swift
//  Travel Diary
//
//  Created by Ingo Böhme on 25.07.20.
//  Copyright © 2020 Ingo Böhme Mobil. All rights reserved.
//

import SwiftUI

struct BuyFullVersionView: View {
    @Environment(\.presentationMode) var presentationMode
    let worldWidth = UIScreen.main.bounds.size.width / 3.5
    let titleFont = Font.system(size: 28, weight: .regular, design: .rounded)

    var body: some View {
        VStack {
            Spacer()
            ZStack {
                HStack {
                    WorldAnimation()
                    Spacer()
                }
                HStack {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 0) {
                        Text(TXT.storeHeadline1).font(self.titleFont)
                        Text(TXT.storeHeadline2).font(self.titleFont)
                        Spacer()
                        Text(TXT.storeSubHeadline).font(.caption)
                            .padding(.bottom, 8)
                    }
                }
            }
            .frame(height: worldWidth)

            Divider().padding(.vertical, 8)

            ScrollView(.vertical, showsIndicators: false) {
                AttributedText(TXT.storeText)
                    .multilineTextAlignment(.leading)

                Button(action: {
                    if let url = URL(string: "itms-apps://itunes.apple.com/app/id1502570695?mt=8") {
                        UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                            self.presentationMode.wrappedValue.dismiss()

                        })
                    }
                }) {
                    Image(TXT.appStoreImage)
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                }
            }
        }
        .padding([.leading, .top, .trailing], 32)
        .background(LinearGradient(gradient: Gradient(colors: [.neoWhite, .neoWhite, .neoLightShadow, .neoWhite]), startPoint: .top, endPoint: .bottom)).edgesIgnoringSafeArea(.all)
    }
}

struct BuyFullVersionView_Previews: PreviewProvider {
    static var previews: some View {
        BuyFullVersionView()
    }
}
