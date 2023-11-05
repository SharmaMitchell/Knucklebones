//
//  ContentView.swift
//  Knucklebones_Prototype
//
//  Created by Mitchell Sharma on 9/23/23.
//

import SwiftUI

enum WinnerType {
    case p1, p2
}

class GameState: ObservableObject {
    @Published var p1board: [[Int]] = Array(repeating: Array(repeating: 0, count: 3), count: 3)
    @Published var p1score: [Int] = [0, 0, 0]
    @Published var p1roll: Int = -1

    @Published var p2board: [[Int]] = Array(repeating: Array(repeating: 0, count: 3), count: 3)
    @Published var p2score: [Int] = [0, 0, 0]
    @Published var p2roll: Int = -1

    @Published var gameInProgress: Bool = false
    @Published var isP1Turn: Bool = true
    @Published var winner: WinnerType? = nil

    @Published var gameDifficulty: String = "Easy"

    @Published var rolls: [Int] = Array(repeating: 0, count: 6)
    @Published var gamesWon: Int = 0
    @Published var gamesPlayed: Int = 0
}

struct ContentView: View {
    @StateObject private var gameState = GameState()

    var body: some View {
        TabView {
            GameView()
                .environmentObject(gameState)
                .tabItem {
                    Label("Game", systemImage: "dice")
                }
            StatsView()
                .environmentObject(gameState)
                .tabItem {
                    Label("Stats", systemImage: "chart.xyaxis.line")
                }
            RulesView()
                .tabItem {
                    Label("Rules", systemImage: "list.bullet")
                }
        }
        .onAppear {
            UITabBar.appearance().unselectedItemTintColor = .white
        }
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
