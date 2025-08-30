// **************************************
// ** Apple   W A T C H   only
// **************************************

import Combine
import CoreLocation
import Foundation

/// Requests from the **Apple Watch** to the phone
extension WatchManager {
    #if os(watchOS)

    func getEntries(from start: Int = 0, count: Int = 10,
                    onSuccess: @escaping ([WKDiaryEntryViewModel]) -> Void,
                    onError: ((WKError) -> Void)? = nil) {
        guard let session = session else {
            onError?(WKError.invalidSession)
            return
        }

        session.sendMessage(["getEntries": ["start": start, "count": count]],
                            replyHandler: { result in
                                if let json = result["success"] as? String,
                                    let entryArray = try? JSONDecoder().decode([WKDiaryEntryViewModel].self, from: Data(json.utf8)) {
                                    onSuccess(entryArray)
                                }
                            },
                            errorHandler: { error in
                                print(error)
                                onError?(WKError.invalidResponse)
        })
    }

    func saveCurrentPosition(onSuccess: @escaping (WKDiaryEntryViewModel) -> Void = { _ in },
                             onError: ((WKError) -> Void)? = nil) {
        guard let session = session else {
            onError?(WKError.invalidSession)
            return
        }

        session.sendMessage(["saveCurrentPosition": [:]],
                            replyHandler: { result in
                                if let json = result["success"] as? String,
                                    let entry = try? JSONDecoder().decode(WKDiaryEntryViewModel.self, from: Data(json.utf8)) {
                                    onSuccess(entry)
                                }
                            },
                            errorHandler: { error in
                                print(error)
                                onError?(WKError.invalidResponse)

        })
    }

    func dispatchRequest(with parameter: WKActionType,
                         onSuccess: @escaping (Data) -> Void,
                         onError: ((WKError) -> Void)? = nil) {
        if let action = parameter["reloadData"] {
            print(action)
            WKDiaryViewModel.shared.reload()
        }
    }

    #endif
}

///
