//
//  DataService.swift
//  ChineseApp
//
//  Created by Billy Orr on 2025-11-07.
//

import Foundation

class DataService {
    // hardcode topics for now
    static let topics: [Topic] = [
        Topic(name: "HSK 1 Part 1", filename: "hsk1_part1"),
        Topic(name: "HSK 1 Part 2", filename: "hsk1_part2")
    ]
    
    static func loadWords(for topic: Topic) -> [Word] {
        guard let url = Bundle.main.url(forResource: topic.filename, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let words = try? JSONDecoder().decode([Word].self, from: data) else {
            print("❌ Failed to load \(topic.filename).json")
            return []
        }
        return words
    }
}
