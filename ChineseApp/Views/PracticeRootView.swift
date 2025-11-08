//
//  PracticeRootView.swift
//  ChineseApp
//
//  Created by Billy Orr on 2025-11-07.
//

import SwiftUI

struct PracticeRootView: View {
    let topics = DataService.topics
    @State private var selectedTopic: Topic?

    var body: some View {
        NavigationStack {
            List(topics) { topic in
                Button {
                    selectedTopic = topic
                } label: {
                    HStack {
                        Text(topic.name)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Practice")
            .navigationDestination(item: $selectedTopic) { topic in
                PracticeSessionView(topic: topic)
            }
        }
    }
}

#Preview {
    PracticeRootView()
}
