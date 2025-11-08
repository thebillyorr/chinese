//
//  ProgressManager.swift
//  ChineseApp
//
//  Created by Billy Orr on 2025-11-07.
//

import Foundation

final class ProgressManager {
    private static let key = "wordProgress"

    // load all progress as [hanzi : 0.0-1.0]
    static func loadProgress() -> [String: Double] {
        UserDefaults.standard.dictionary(forKey: key) as? [String: Double] ?? [:]
    }

    // save full map back
    static func save(_ dict: [String: Double]) {
        UserDefaults.standard.set(dict, forKey: key)
    }

    // add delta, cap at 1.0
    static func addProgress(for hanzi: String, delta: Double) {
        var current = loadProgress()
        let newValue = min((current[hanzi] ?? 0) + delta, 1.0)
        current[hanzi] = newValue
        save(current)
    }

    // convenience getter
    static func getProgress(for hanzi: String) -> Double {
        loadProgress()[hanzi] ?? 0
    }

    // reset (optional for testing)
    static func resetAll() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
