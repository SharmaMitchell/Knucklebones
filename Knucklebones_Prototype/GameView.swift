//
//  GameView.swift
//  Knucklebones_Prototype
//
//  Created by Mitchell Sharma on 9/23/23.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject private var gameState: GameState
    
    @State private var showingDifficulty = false
    let difficultyOptions = ["Easy", "Hard"]
    
    let lambAnimations = ["Lamb-dance", "Lamb-evil"]
    var currentAnimation: String {
        let animationIndex = difficultyOptions.firstIndex(of: gameState.gameDifficulty)!
        return lambAnimations[animationIndex]
    }
    
    @ViewBuilder
    func landingScreen() -> some View {
        VStack {
            Image("knucklebones")
                .resizable()
                .frame(width: 353, height: 136)
            Spacer()
            GIFImage(name: currentAnimation)
                .frame(width: 245, height: 271)
            Spacer()
            Image("play_button")
                .resizable()
                .frame(width: 250, height: 60)
                .padding(.all, 5)
                .onTapGesture {
                    gameState.gameInProgress = true
                }
            Image("difficulty_button")
                .resizable()
                .frame(width: 250, height: 60)
                .padding(.all, 5)
                .onTapGesture {
                    showingDifficulty = true
                }
                .confirmationDialog("Choose Difficulty", isPresented: $showingDifficulty, titleVisibility: .visible) {
                    ForEach(difficultyOptions, id: \.self) { difficulty in
                        Button(difficulty) {
                            gameState.gameDifficulty = difficulty
                        }
                    }
                }
            Spacer()
        }
    }
    
    @ViewBuilder
    func opponentPanel() -> some View {
        HStack{
            VStack{
                Text("Ratau")
                    .font(Font.custom("Piazzolla", size: 16))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(Color("TextColor"))
                Text("Score: \(gameState.p2score)")
            }
            
            // TODO: Add dice roll area & animation logic
            
            //Image() // TODO: Add opponent Image
        }
    }
    
    @ViewBuilder
    func playerPanel() -> some View {
        VStack {
            HStack {
                
            }
            HStack {
                Button("Quit"){
                    gameState.p1board = Array(repeating: Array(repeating: 0, count: 3), count: 3)
                    gameState.p2board = Array(repeating: Array(repeating: 0, count: 3), count: 3)
                    gameState.p1score = 0
                    gameState.p2score = 0
                    gameState.gamesPlayed += 1
                    gameState.gameInProgress = false
                }
                
                //TODO: Add dice roll area & animation logic
                
                Button("Roll"){
                    
                }
            }
        }
    }
    
    @ViewBuilder
    func playerBoard(isOpponent: Bool) -> some View {
        // Board direction based on isOpponent (face upwards unless isOpponent)
        
    }
    
    @ViewBuilder
    func inGameScreen() -> some View {
        VStack{
            opponentPanel()
            playerBoard(isOpponent: true)
            playerBoard(isOpponent: false)
            playerPanel()
        }
    }
    
    var body: some View{
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // Set the background to black
            
            VStack{
                Image("eyes_top")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Spacer()
                    .frame(height: 130)
                Image("eyes_bottom")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.bottom, 60)
                    .padding(.leading, 110)
            }
            
            if(gameState.gameInProgress == false){
                landingScreen()
                .padding()
            } else {
                inGameScreen()
                .padding()
            }
        }
    }
}
