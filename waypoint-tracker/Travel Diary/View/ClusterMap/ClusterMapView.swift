import MapKit
import SwiftUI

struct ClusterMapView: UIViewRepresentable {
    @ObservedObject private var viewModel = ClusterMapViewModel()
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(center: Settings.lastLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    private let mapView = MKMapView()

    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true

        LocationPublisher.shared.execute {
            location in
            self.setRegion(
                region:
                MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.2,
                        longitudeDelta: 0.2
                    )
                ), force: true
            )
        }

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {}

    func setRegion(region: MKCoordinateRegion, force: Bool = false) {
        viewModel.setRegion(newRegion: region, force: force) {
            _ in

            self.mapView.removeAnnotations(self.mapView.annotations)

            DispatchQueue.main.async {
                self.region = region
                self.mapView.region = self.viewModel.region
                for annotation in self.viewModel.visits {
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: ClusterMapView

        init(_ parent: ClusterMapView) {
            self.parent = parent
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            let region = mapView.region

            parent.setRegion(region: region)
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard annotation is MKPointAnnotation else { return nil }

            let identifier = "visits"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
            } else {
                annotationView!.annotation = annotation
            }

            annotationView?.clusteringIdentifier = "visit"
            return annotationView
        }
    }
}
