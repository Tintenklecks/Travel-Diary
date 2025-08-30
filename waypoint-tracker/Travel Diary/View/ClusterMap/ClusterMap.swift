//
//  ClusterMap.swift
//  Travel Diary
//
//  Created by Ingo Böhme on 26.05.20.
//  Copyright © 2020 Ingo Böhme Mobil. All rights reserved.
//

import SwiftUI

struct ClusterMap: View {
    var body: some View {
        IBNavigationView(title: TXT.visitedPlaces, actionView: Text("")) {
            ZStack {
                ClusterMapView()
                VStack {
                
                    Banner().shadow(radius: 20).padding(.vertical, 32)
                    Spacer()
                }
            }
        }
    }
}

struct ClusterMap_Previews: PreviewProvider {
    static var previews: some View {
        ClusterMap()
    }
}
