//

import Foundation

extension String {
    var localized: String {
        if self.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            print( "WHAAT")
        }
        let translated = NSLocalizedString(self, comment: "")
        return translated
            .replacingOccurrences(of: "\\n", with: "\n")
    }
}
