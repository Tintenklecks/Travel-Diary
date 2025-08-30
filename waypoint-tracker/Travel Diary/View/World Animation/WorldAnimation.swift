//
//  WorldAnimation.swift
//  World Cloud Animation
//
//  Created by Ingo Böhme on 14.07.20.
//  Copyright © 2020 Ingo Böhme. All rights reserved.
//

import SwiftUI

struct WorldAnimation: View {
    @State private var animating: Bool = false
    let animation = Animation.linear(duration: 500).repeatForever()

    var body: some View {
        ZStack {
            Image("world-clouds").resizable()
                .scaledToFit()
                .rotationEffect(Angle(degrees: animating ? -3600 : 0))
            Image("world").resizable()
                .scaledToFit()
                .rotationEffect(Angle(degrees: animating ? 360 : 0))
            Image("world-plane").resizable()
                .scaledToFit()
                .rotationEffect(Angle(degrees: animating ? 14400 : 0))
        }
        .onAppear {
            self.animating.toggle()
        }
        .animation(self.animation)
    }
}

struct WorldAnimation_Previews: PreviewProvider {
    static var previews: some View {
        WorldAnimation()
    }
}
