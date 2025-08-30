//
//  SetWaypointView.swift
//  Waypoint Tracker
//
//  Created by Ingo Böhme on 20.03.20.
//  Copyright © 2020 Ingo Böhme Mobil. All rights reserved.
//

import SwiftUI

struct SetWaypointView: View {
    @State var title: String = ""
    @State var text: String = ""
    @State var startTime: Date = Date()
    @State var endTime: Date = Date().addingTimeInterval(600)

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }

    var body: some View {
        VStack {
            Form {
                Text("Add Visit").font(.title)
                TextField("Waypoint / Visit Title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Description", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(4)

                ZStack {
                    Text("Hallo")
                }.background(Color.red)
                    .shadow(color: .white, radius: 6, x: -3, y: -3)
                .shadow(color: .black, radius: 6, x: 3, y: 3)
                    .padding(2)
                    .clipped()
                DatePicker("Start of visit", selection: $startTime, displayedComponents: .date)
                DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)

                DatePicker("End of visit", selection: $endTime, displayedComponents: .date)
                DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
                HStack {
                    Text("Duration")
                    Spacer()
                    Text(startTime.distance(to: endTime).timeString())
                }
            }.padding([.leading, .trailing], 32)
        }.background(Color.neoWhite)
    }
}

struct SetWaypointView_Previews: PreviewProvider {
    static var previews: some View {
        SetWaypointView()
    }
}
