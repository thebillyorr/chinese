//
//  ContentView.swift
//  ChineseApp
//
//  Created by Billy Orr on 2025-11-07.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PracticeRootView()
                .tabItem {
                    Label("Practice", systemImage: "rectangle.stack.badge.play")
                }
            
            DictionaryView()
                .tabItem {
                    Label("Dictionary", systemImage: "book")
                }
        }
    }
}

#Preview {
    ContentView()
}


