//
//  ContentView.swift
//  Knucklebones_Prototype
//
//  Created by Mitchell Sharma on 9/23/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            GameView()
                .tabItem{
                    Label("Game", systemImage: "dice")
                }
            StatsView()
                .tabItem{
                    Label("Stats", systemImage: "chart.xyaxis.line")
                        .foregroundColor(.white)
                }
            RulesView()
                .tabItem{
                    Label("Rules", systemImage: "list.bullet")
                }
        }
        .onAppear {
            // Set the initial tab's label color to white
            UITabBar.appearance().unselectedItemTintColor = .white
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
