//
//  Word.swift
//  ChineseApp
//
//  Created by Billy Orr on 2025-11-07.
//

import Foundation

struct Word: Codable, Identifiable {
    let id = UUID()
    let hanzi: String
    let pinyin: String
    let english: String
    let level: Int
}
