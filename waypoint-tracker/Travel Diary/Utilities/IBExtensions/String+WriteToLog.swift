 //
 
 import Foundation

public extension FileManager {
    static let documentDirectoryURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    static let logUrl = documentDirectoryURL.appendingPathComponent("log.log")
}

public extension String {
    func saveToLog(append: Bool = true) {
        print("Logged:\n\(self)")
        let content = self + (append ? "\n" + String.readFromLog() : "")
        try? content.write(to: FileManager.logUrl, atomically: true, encoding: .utf8)
    }

    static func readFromLog() -> String {
        do {
            guard FileManager.default.fileExists(atPath: FileManager.logUrl.path) else {
                return ""
            }
            let content = try String(contentsOf: FileManager.logUrl, encoding: .utf8)
            return content
        } catch {
        }
        return ""
    }

    static func resetLog() {
        "".saveToLog(append: false)
    }
}
