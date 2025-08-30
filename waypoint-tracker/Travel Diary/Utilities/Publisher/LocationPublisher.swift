//
//  LocationManager.swift
//  Destination Compass
//
//  Created by Ingo Böhme on 07.12.19.
//  Copyright © 2019 Ingo Böhme. All rights reserved.
//

import Combine
import CoreLocation
import Foundation
import SwiftUI

final class LocationViewModel: NSObject, ObservableObject {
    override init() {
        super.init()
        
        manager.delegate = self
        manager.startUpdatingHeading()

    }
    
     let manager: CLLocationManager = CLLocationManager()
    
    @Published var heading: Double = 0

}

extension LocationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.heading = newHeading.magneticHeading
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Auth Status: \(status.rawValue)")
    }

}

//struct Location {
//
//    @Binding var headingAngle: Double
//
////    init() {
////
////        manager.headingChanged = { newHeading in
////  //          self.headingAngle = newHeading.magneticHeading as Double
////        }
////        headingAngle = 0
////    }
//}

//private class LocationManager: CLLocationManager,  {
//
//    var headingChanged: (CLHeading) -> () = { _ in }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
//        headingChanged(newHeading)
//        print(newHeading)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        print("Auth Status: \(status.rawValue)")
//    }
//}

extension Double {
    var inRadians: Double {
        return self / 180 * Double.pi
    }
}
