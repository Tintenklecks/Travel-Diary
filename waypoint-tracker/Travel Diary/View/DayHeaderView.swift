//
//  DayHeaderView.swift
//  Waypoint Tracker
//
//  Created by Ingo Böhme on 09.03.20.
//  Copyright © 2020 Ingo Böhme Mobil. All rights reserved.
//

import SwiftUI

struct DayHeaderView: View {
    let date: Date

    var body: some View {
        
        DateSquareView(date: date, condensed: true)
            .foregroundColor(Color.imageTag)
            .padding(.leading, 16)
//        Text("\(date.weekdayAbbrevation.uppercased()) \(date.day(leadingZero: true)) \(date.monthAbbrevation.uppercased())")
//        .font(Font.system(size: 24, weight: .light, design: .rounded))
    }
}

//struct DayHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        DayHeaderView()
//    }
//}
