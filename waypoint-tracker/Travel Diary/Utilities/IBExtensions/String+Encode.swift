//
//  File.swift
//
//
//  Created by Ingo Böhme on 29.07.20.
//

import Foundation

public extension String {
    var encoded: String {
        var result = self.replacingOccurrences(of: "\\", with: "\\\\")
        result = self.replacingOccurrences(of: "\"", with: "\\\"")
        return result
    }
}
