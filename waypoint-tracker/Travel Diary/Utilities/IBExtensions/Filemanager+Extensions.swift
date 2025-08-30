//
//  File.swift
//  
//
//  Created by Ingo Böhme on 26.07.20.
//

import Foundation

public extension FileManager {
    static func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    static func cacheDirectory() -> URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    static func fileURL(name: String, inCache: Bool = false) -> URL {
        if inCache {
            return self.cacheDirectory().appendingPathComponent(name)
        } else {
            return self.documentsDirectory().appendingPathComponent(name)
        }
    }
}

