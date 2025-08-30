//
//  DateSquareView.swift
//  Waypoint Tracker
//
//  Created by Ingo Böhme on 07.03.20.
//  Copyright © 2020 Ingo Böhme Mobil. All rights reserved.
//

import SwiftUI

struct DateSquareView: View {
    let date: Date
    let condensed: Bool

    var body: some View {
                if self.condensed {
            return AnyView(HStack {
                Text("\(date.weekdayAbbrevation.uppercased()) \(date.day(leadingZero: true)) \(date.monthAbbrevation.uppercased())")
                .bold()
            })

        } else {
            return AnyView(VStack {
                Text(date.weekdayAbbrevation.uppercased())
                Text(date.day(leadingZero: true)).font(.largeTitle)
                Text(date.monthAbbrevation.uppercased())
            }.foregroundColor(Color.imageTag))
        }

    }
}

//struct DateSquareView_Previews: PreviewProvider {
//    static var previews: some View {
//        DateSquareView(date: Date())
//    }
//}
