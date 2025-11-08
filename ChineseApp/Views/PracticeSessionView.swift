//
//  PracticeSessionView.swift
//  ChineseApp
//
//  Created by Billy Orr on 2025-11-07.
//

import SwiftUI

struct PracticeSessionView: View {
    let topic: Topic
    @State private var words: [Word] = []
    @State private var currentIndex: Int = 0
    @State private var seenCounts: [String: Int] = [:] // hanzi -> times seen this session
    @State private var showAnswer = false
    @State private var isQuiz = false
    @State private var showSummary = false
    @State private var sessionMastered: [String] = []


    
    // session size rule: up to 2x words, min words.count
    private var sessionSize: Int {
        min(words.count * 2, 15)
    }
    
    var body: some View {
        VStack {
            if showSummary {
                // --- Summary screen ---
                VStack(spacing: 20) {
                    Text("🎉 Session Complete 🎉")
                        .font(.title2)
                        .padding(.top, 40)
                    Text("You practiced \(words.count) words.")
                        .font(.headline)
                        .padding(.bottom, 8)

                    if sessionMastered.isEmpty {
                        Text("No words were mastered during this session.")
                            .foregroundColor(.secondary)
                            .padding(.bottom, 12)
                    } else {
                        Text("Words mastered:")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(sessionMastered, id: \.self) { hanzi in
                                if let w = words.first(where: { $0.hanzi == hanzi }) {
                                    HStack {
                                        Text(w.hanzi)
                                            .font(.title3)
                                        VStack(alignment: .leading) {
                                            Text(w.pinyin)
                                                .foregroundColor(.secondary)
                                                .font(.subheadline)
                                            Text(w.english)
                                                .foregroundColor(.secondary)
                                                .font(.subheadline)
                                        }
                                    }
                                } else {
                                    Text(hanzi)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }

                    Button("Done") {
                        // reset session
                        showSummary = false
                        seenCounts.removeAll()
                        currentIndex = 0
                        sessionMastered.removeAll()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGroupedBackground))
            } else {
                // --- Main practice session ---
                VStack(spacing: 20) {
                    if words.isEmpty {
                        Text("Loading...")
                    } else {
                        Text(topic.name)
                            .font(.headline)

                        if isQuiz {
                            quizView
                        } else {
                            flashcardView
                        }


                            if !isQuiz {
                                HStack {
                                    Button("I don’t know") {
                                        advanceWord(correct: false)
                                    }
                                    .buttonStyle(.bordered)

                                    Button("I got it") {
                                        advanceWord(correct: true)
                                    }
                                    .buttonStyle(.borderedProminent)
                                }
                                .transition(.opacity)
                            }
                    }
                }
                .padding()
                .onAppear {
                    words = DataService.loadWords(for: topic)
                    currentIndex = 0
                    isQuiz = false
                }
                

            }
        }
    }


    
    private var flashcardView: some View {
        let word = words[currentIndex]
        return VStack(spacing: 12) {
            Text(word.hanzi)
                .font(.system(size: 60))
                .onTapGesture {
                    withAnimation {
                        showAnswer.toggle()
                    }
                }
            if showAnswer {
                Text(word.english)
                    .font(.title3)
                Text(word.pinyin)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    // simplest quiz: show hanzi, pick english
    private var quizView: some View {
        let word = words[currentIndex]
        let options = makeOptions(correct: word)
        
        return VStack(spacing: 12) {
            Text(word.hanzi)
                .font(.system(size: 48))
            Text("Choose the meaning:")
            ForEach(options, id: \.self) { option in
                Button(option) {
                    let correct = (option == word.english)
                    advanceWord(correct: correct)
                }
                .buttonStyle(.bordered)
            }
        }
    }
    
    private func makeOptions(correct: Word) -> [String] {
        // take up to 3 other words as distractors
        let others = words.filter { $0.hanzi != correct.hanzi }.shuffled().prefix(3).map { $0.english }
        return ([correct.english] + others).shuffled()
    }
    
    private func advanceWord(correct: Bool) {
        showAnswer = false
        let word = words[currentIndex]

        // record progress if correct
        if correct {
            let delta = isQuiz ? 0.3 : 0.1
            ProgressManager.addProgress(for: word.hanzi, delta: delta)
            // if progress reached 100% record it for session summary (no immediate popup)
            let progress = ProgressManager.getProgress(for: word.hanzi)
            if progress >= 1.0 {
                if !sessionMastered.contains(word.hanzi) {
                    sessionMastered.append(word.hanzi)
                }
            }
        }

        

        // update seen count
        var count = seenCounts[word.hanzi, default: 0]
        count += 1
        seenCounts[word.hanzi] = count

        // filter out words already seen 3×
        let remaining = words.filter { (seenCounts[$0.hanzi] ?? 0) < 3 }

        if remaining.isEmpty {
            showSummary = true
            return
        }

        // choose next word randomly from remaining
        if let next = remaining.randomElement(),
           let nextIndex = words.firstIndex(where: { $0.hanzi == next.hanzi }) {
            currentIndex = nextIndex
        }

        // after at least one view, randomly decide quiz vs flashcard
        isQuiz = (count >= 1) ? Bool.random() : false
    }


}


#Preview {
    PracticeSessionView(topic: Topic(name: "HSK 1 Part 1", filename: "hsk1_part1"))
}
