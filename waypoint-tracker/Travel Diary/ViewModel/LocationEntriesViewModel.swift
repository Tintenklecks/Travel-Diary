import SwiftUI
import Combine
import os.log

///
/// # LocationEntriesViewModel
 // swiftlint:disable unused_closure_parameter
// swiftlint:disable file_length


class Location {
    
    

    static func locationName (for id: String) -> String {
        return RLMLocationEntry.name(for: id)
    }
    
    static func update(location id: String, with name: String) {
        RLMLocationEntry.update(location: id, name: name)
    }
    

    
}

