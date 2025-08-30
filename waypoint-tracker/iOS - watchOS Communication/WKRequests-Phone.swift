// **************************************
// ** i P H O N E  only
// **************************************

import Combine
import CoreLocation
import Foundation

/// Handling the requests on the **iPHONE**

extension WatchManager {
    // MARK: - Dispatcher of the watch requests only for iOS

    #if os(iOS)
    /// The dispatch method handles all requests and gives back the result as a JSON Data format
    func dispatchRequest(with parameter: WKActionType,
                         onSuccess: @escaping (Data) -> Void,
                         onError: ((WKError) -> Void)? = nil) {
        for (endpoint, request) in parameter {
            switch endpoint {
            case "getEntries":
                if let start = request["start"] as? Int,
                    let count = request["count"] as? Int {
                    let entries = WKDiaryViewModel.getNextEntries(start: start, count: count)
                    if let entriesData = try? JSONEncoder().encode(entries) {
                        onSuccess(entriesData)
                    }
                    onError?(.invalidData)
                }
            case "saveCurrentPosition":
                LocationPublisher.shared.execute { _ in
                    let record = DiaryViewModel.addCurrentPosition()
                    let entry = WKDiaryEntryViewModel(
                        arrival: record.arrival, departure: record.departure,
                        latitude: record.latitude, longitude: record.longitude,
                        locationName: record.locationName, favorite: record.isFavorite)
                    if let entriesData = try? JSONEncoder().encode(entry) {
                        onSuccess(entriesData)
                    }
                }

            default:
                break // all endpoints must be handled explicitly
            }
        }
    }
    #endif
}
