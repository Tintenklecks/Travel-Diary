//
//  PlacemarkResultCell.swift
//  Travel Diary
//
//  Created by Ingo Böhme on 11.06.20.
//  Copyright © 2020 Ingo Böhme Mobil. All rights reserved.
//

import SwiftUI

struct PlacemarkResultCell: View {
    @State var placemark: Placemark
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(placemark.name).font(.headline).foregroundColor(.highlight)
                Text(placemark.localizedAddress(seperated: "\n"))
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(placemark.isoCountryCode.flag)
                Text("\(Int(placemark.distance)) m") // TODO: imperial / metric
            }
        }
    }
}

