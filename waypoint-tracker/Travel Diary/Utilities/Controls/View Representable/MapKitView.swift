import MapKit
import SwiftUI

struct MapKitView: View {
    let location: CLLocationCoordinate2D // meter
    var radius: Double = 2000
    @Binding var style: Int
    var body: some View {
        MapViewRepresentable(center: location, radius: radius, style: $style)
    }
}

struct MapViewRepresentable: UIViewRepresentable {
    let center: CLLocationCoordinate2D
    var radius: Double = 2000
   @Binding var style: Int

    func makeUIView(context: UIViewRepresentableContext<MapViewRepresentable>) -> MKMapView {
        let mapView = MKMapView()
        mapView.mapType = MapStyle.from(value: style).style
        mapView.centerCoordinate = center
        mapView.region = MKCoordinateRegion(center: center, latitudinalMeters: radius, longitudinalMeters: radius)
        let annotation = MKPointAnnotation()
        annotation.title = TXT.youWereHere
        annotation.subtitle = "\(center.latitude.latitudeString)\n\(center.longitude.longitudeString)"
        annotation.coordinate = center

        mapView.addAnnotation(annotation)
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: UIViewRepresentableContext<MapViewRepresentable>) {
        view.mapType = MapStyle.from(value: style).style
    }
    
}

