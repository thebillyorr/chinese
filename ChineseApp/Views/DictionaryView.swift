//
//  DictionaryView.swift
//  ChineseApp
//
//  Created by Billy Orr on 2025-11-07.
//

import SwiftUI

struct DictionaryView: View {
    let topics = DataService.topics
    @State private var expandedTopicID: UUID? = nil
    @State private var progress = ProgressManager.loadProgress()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(topics) { topic in
                    Section {
                        Button {
                            // toggle expansion
                            if expandedTopicID == topic.id {
                                expandedTopicID = nil
                            } else {
                                expandedTopicID = topic.id
                            }
                        } label: {
                            HStack {
                                Text(topic.name)
                                    .font(.headline)
                                Spacer()
                                Image(systemName: expandedTopicID == topic.id ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                        
                        if expandedTopicID == topic.id {
                            let words = DataService.loadWords(for: topic)
                            ForEach(words) { word in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(word.hanzi)
                                        .font(.title3)
                                    Text("\(word.pinyin) – \(word.english)")
                                        .foregroundColor(.secondary)
                                        .font(.subheadline)
                                    // placeholder progress for now
                                    let pct = Int((progress[word.hanzi] ?? 0) * 100)
                                    if pct == 100 {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                    }
                                    Text("Progress: \(pct)%")
                                        .font(.caption)
                                        .foregroundColor(pct == 100 ? .green : .blue)

                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Dictionary")
            .onAppear {
                progress = ProgressManager.loadProgress()
            }
        }
    }
}

#Preview {
    DictionaryView()
}
