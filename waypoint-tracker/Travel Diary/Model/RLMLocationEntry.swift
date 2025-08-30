/// Model to cache entries from requests
import CoreLocation
import Foundation
import RealmSwift
// import IBExtensions

enum LocationSource: Int {
    case apple
    case google
    case wikipedia
}

protocol JSONExport {
    var asJSON: String { get }
    static var asJSON: String { get }
}

class RLMLocationEntry: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var language: String = ""

    @objc dynamic var isPlacemark: Bool = false

    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    @objc dynamic var source: Int = LocationSource.apple.rawValue
    @objc dynamic var url: String = ""
    @objc dynamic var thumbnail: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - Convert to JSON String

extension RLMLocationEntry: JSONExport {
    var asJSON: String {
        return """
        {
        "id":"\(id.encoded)",
        "name":"\(name.encoded)",
        "language":"\(language)",
        "isPlacemark":\(isPlacemark ? "true" : "false"),
        "latitude":\(latitude),
        "longitude":\(longitude),
        "source":\(source),
        "url":"\(url)",
        "thumbnail":"\(thumbnail)"
        }
        """
    }

    static var asJSON: String {
        let array = db.realm
            .objects(RLMLocationEntry.self)
            .sorted(byKeyPath: "name", ascending: true)

            .map { $0.asJSON }
        return "\"RLMLocationEntry\":[\(array.joined(separator: ","))]"
    }
}
