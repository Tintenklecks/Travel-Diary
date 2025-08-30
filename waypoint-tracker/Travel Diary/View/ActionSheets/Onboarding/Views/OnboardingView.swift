//
//  OnboardingView.swift
//  Onboarding
//
//  Created by Ingo Böhme on 23.06.20.
//  Copyright © 2020 Ingo Böhme. All rights reserved.
//

import SwiftUI

struct OnboardingView: View {
    @State private var viewModel = OnboardingViewModel()
    @State private var id: String = ""
        

    @State private var animation: Bool = false

    var body: some View {
        ZStack {
            viewModel.color.background.edgesIgnoringSafeArea(.all)
            OnboardingTopicsView(id: self.$id)
                .padding(32)
                .environmentObject(viewModel)
        }
        .foregroundColor(viewModel.color.text)
        .sheet(isPresented: .constant(self.id != ""),
               onDismiss: {
                self.id = ""
                
        }) {
            OnboardingSceneView(id: self.$id)
                .environmentObject(self.viewModel)
                .edgesIgnoringSafeArea(.all)
                .id(UUID())
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
