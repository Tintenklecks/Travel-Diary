//
//  ActivityIndicatorView.swift
//  Travel Diary
//
//  Created by Ingo Böhme on 12.06.20.
//  Copyright © 2020 Ingo Böhme Mobil. All rights reserved.
//

import SwiftUI

struct ActivityIndicatorView: View {
    var isPresented: Bool = false
    var message: String = ""
    
    private var nothingView: some View { Color.clear.frame(width: 0, height: 0) }
    
    private var activityView: some View {
        ZStack {
            Color.activityDark
            ActivityIndicator(type: .spinningCircles)
                .frame(width: 64, height: 64)
            Text(message)
                .offset(x: 0, y: 64)
                .padding(.vertical, 64)
        }
        .foregroundColor(.activityLight)
        .edgesIgnoringSafeArea(.all)
    }
    
    var body: some View {
        isPresented ? activityView.asAnyView() : nothingView.asAnyView()
    }
}
