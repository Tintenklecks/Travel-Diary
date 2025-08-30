//
//  Copyright Ingo Böhme Mobil 2020. All rights reserved.
import Combine
import CoreLocation
import MapKit
import os.log
import SwiftUI

///
/// # ClusterMapViewModel
// swiftlint:disable unused_closure_parameter
// swiftlint:disable file_length

class ClusterMapViewModel: ObservableObject {
    @Published var locations: [MKPointAnnotation] = []
    @Published var visits: [MKPointAnnotation] = []

//    var center = CLLocationCoordinate2D()
//    var isSet: Bool = false
//
    var region: MKCoordinateRegion = MKCoordinateRegion(center: Settings.lastLocation.coordinate, latitudinalMeters: 0.5, longitudinalMeters: 0.5)

    var delayTimer: Timer = Timer()

    func setRegion(newRegion: MKCoordinateRegion, force: Bool = false, annotations: @escaping ([MKAnnotation]) -> Void) {
        self.delayTimer.invalidate()

        if force {
            self.region = newRegion
            self.getAnnotations(in: newRegion)
            annotations(self.visits)

            return
        }
        if self.region.contains(region: newRegion) {
            // Do nothing
            return
        }

        if self.region.span.shiftDistance(span: newRegion.span) < self.region.span.diagonalDistance / 10 {
            // Do nothing ... too small
            return
        }

        self.delayTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { [weak self] _ in
            if let self = self {
                self.region = newRegion
                self.getAnnotations(in: newRegion)
                annotations(self.visits)
            }
        })
    }

    private func getAnnotations(in region: MKCoordinateRegion) {
        self.visits =
            DiaryViewModel.allEntries(in: region.mapRect)
            .map { entry in
                let annotation = MKPointAnnotation()
                annotation.title = entry.locationName
                annotation.coordinate = entry.coordinate
                annotation.subtitle = entry.text
                return annotation
            }
    }
}

// extension ClusterMapViewModel: Equatable {
//    static func == (lhs: ClusterMapViewModel, rhs: ClusterMapViewModel) -> Bool {
//        return lhs.center == rhs.center
//    }
// }

extension MKCoordinateRegion {
    func contains(region: MKCoordinateRegion) -> Bool {
        return self.mapRect.contains(region.mapRect)
    }

    var mapRect: MKMapRect {
        let topLeft = CLLocationCoordinate2D(latitude: self.center.latitude + (self.span.latitudeDelta / 2), longitude: self.center.longitude - (self.span.longitudeDelta / 2))
        let bottomRight = CLLocationCoordinate2D(latitude: self.center.latitude - (self.span.latitudeDelta / 2), longitude: self.center.longitude + (self.span.longitudeDelta / 2))

        let a = MKMapPoint(topLeft)
        let b = MKMapPoint(bottomRight)

        return MKMapRect(origin: MKMapPoint(x: min(a.x, b.x), y: min(a.y, b.y)), size: MKMapSize(width: abs(a.x - b.x), height: abs(a.y - b.y)))
    }
}

extension MKCoordinateSpan {
    func shiftDistance(span: MKCoordinateSpan) -> CLLocationDegrees {
        let deltaLatitude = span.latitudeDelta - self.latitudeDelta
        let deltaLongitude = span.longitudeDelta - self.longitudeDelta
        let delta = sqrt(deltaLatitude ^ 2 + deltaLongitude ^ 2)
        return delta
    }

    var diagonalDistance: CLLocationDegrees {
        return sqrt(latitudeDelta ^ 2 + longitudeDelta ^ 2)
    }
}

extension Double {
    static func ^ (base: Double, exponent: Int) -> Double {
        var result: Double = 1
        for _ in 1...exponent {
            result = result * base
        }
        return base
    }
}
