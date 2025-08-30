//
//  MapStyle.swift
//  Travel Diary
//
//  Created by Ingo Böhme on 01.08.20.
//  Copyright © 2020 Ingo Böhme Mobil. All rights reserved.
//

import Foundation
import MapKit

enum MapStyle: Int {
    case map = 0
    case satellite
    case hybrid

    static func from(value: Int) -> MapStyle {
        switch value {
        case 1: return .satellite
        case 2: return .hybrid
        default: return .map
        }
    }

    #if os(iOS)
    var style: MKMapType {
        switch self {
        case .satellite:
            return .satellite
        case .hybrid:
            return .hybrid
        default:
            return .standard
        }
    }
    #endif
}
