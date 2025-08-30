import CoreLocation
import PhotosUI
import RealmSwift
import SwiftUI

class RLMImageReference: Object {
    @objc dynamic var identifier: String = ""
    @objc dynamic var timeStamp: Date = Date.distantPast
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
    
}
