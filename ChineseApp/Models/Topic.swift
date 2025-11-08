//
//  Topic.swift
//  ChineseApp
//
//  Created by Billy Orr on 2025-11-07.
//

import Foundation

struct Topic: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let filename: String

    init(id: UUID = UUID(), name: String, filename: String) {
        self.id = id
        self.name = name
        self.filename = filename
    }
}
