//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by Nilakshi Roy on 2022-11-08.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
