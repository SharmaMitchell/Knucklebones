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
    
    @State private var isWhite = false
    @State private var isFlashing = false
    @State private var previewDieInCol: [Int] = [-1, -1, -1]
    
    @State private var opponentAnimation = "Ratau-idle"
    
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
                .frame(width: 250, height: 80)
                .padding(.all, 5)
                .onTapGesture {
                    gameState.gameInProgress = true
                }
            Image("difficulty_button")
                .resizable()
                .frame(width: 250, height: 80)
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
        HStack {
            VStack {
                HStack {
                    VStack {
                        Spacer()
                        Text("Ratau")
                            .font(Font.custom("Piazzolla", size: 16))
                            .fontWeight(.semibold)
                            .foregroundColor(Color("TextColor"))
                            .padding(.leading, 40)
                    }
                    Spacer()
                    GIFImage(name: opponentAnimation)
                        .frame(width: 70, height: 70)
                    Spacer()
                    VStack {
                        Spacer()
                        Text("Score: \(gameState.p2score.reduce(0, +))")
                            .font(Font.custom("Piazzolla", size: 16))
                            .fontWeight(.semibold)
                            .foregroundColor(Color("TextColor"))
                            .padding(.trailing, 40)
                    }
                }
            }
            
            // TODO: Add dice roll area & animation logic
        }
    }
    
    @ViewBuilder
    func playerPanel() -> some View {
        VStack {
            HStack {
                Text("The Lamb")
                    .font(Font.custom("Piazzolla", size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(Color("TextColor"))
                    .padding(.leading, 40)
                Spacer()
                Text("Score: \(gameState.p1score.reduce(0, +))")
                    .font(Font.custom("Piazzolla", size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(Color("TextColor"))
                    .padding(.trailing, 40)
            }
            HStack {
                Image("quit_button")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 110, height: 60)
                    .onTapGesture {
                        resetGame()
                    }
                
                // TODO: Add dice roll area & animation logic
                Spacer()
                    .frame(width: 60)
                
                Image("roll_button_2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 110, height: 60)
                    .onTapGesture {
                        if gameState.isP1Turn {
                            rollDie(isOpponent: false)
                        }
                    }
            }
        }
    }
    
    func rollDie(isOpponent: Bool) {
        let randomRoll = Int.random(in: 1 ... 6)
        if isOpponent == true {
            gameState.p2roll = randomRoll
            return
        }
        gameState.p1roll = randomRoll
        gameState.rolls[randomRoll - 1] += 1
    }
    
    func addDieToCol(col: Int, die: Int) {
        for i in 0..<3 {
            if gameState.p1board[i][col] == 0 {
                gameState.p1board[i][col] = die
                return
            }
        }
    }
    
    func flash() {
        withAnimation(Animation.easeInOut(duration: 0.75).repeatForever()) {
            isWhite.toggle()
        }
    }
    
    func twoInCol(num: Int, col: Int, isOpponent: Bool) -> Bool {
        let board = isOpponent ? gameState.p2board : gameState.p1board
        
        if num == 0 {
            return false
        }

        for row in 0..<3 {
            if board[row][col] == num {
                for otherRow in (row + 1)..<3 {
                    if board[otherRow][col] == num {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    func threeInCol(col: Int, isOpponent: Bool) -> Bool {
        if !isOpponent {
            if gameState.p1board[2][col] == 0 {
                return false
            }
            return gameState.p1board[0][col] == gameState.p1board[1][col] && gameState.p1board[1][col] == gameState.p1board[2][col]
        }
        if gameState.p2board[2][col] == 0 {
            return false
        }
        
        return gameState.p2board[0][col] == gameState.p2board[1][col] && gameState.p2board[1][col] == gameState.p2board[2][col]
    }
    
    func calculateColSum(colNums: [Int]) -> Int {
        if colNums[0] == colNums[1] && colNums[1] == colNums[2] {
            // All three numbers are the same, triple the value
            return colNums[0] * 9
        } else if colNums[0] == colNums[1] {
            // Two numbers are the same, double the value
            return colNums[2] + (colNums[0] * 4)
        } else if colNums[0] == colNums[2] {
            // Two numbers are the same, double the value
            return colNums[1] + (colNums[2] * 4)
        } else if colNums[1] == colNums[2] {
            // Two numbers are the same, double the value
            return colNums[0] + (colNums[1] * 4)
        } else {
            // All numbers are distinct, sum them up
            return colNums.reduce(0, +)
        }
    }
    
    func opponentTurn() {
        print("Starting opponentTurn")
        opponentAnimation = "Ratau-roll"
        rollDie(isOpponent: true)
        var possibleCols = [0, 1, 2]
        var randomCol = possibleCols.randomElement() ?? -1
        while gameState.p2board[2][randomCol] != 0 && possibleCols.count > 0 {
            possibleCols.removeAll { $0 == randomCol }
            randomCol = possibleCols.randomElement()!
        }
        if randomCol == -1 {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            print("Inside asyncAfter closure")
            print("randomCol: \(randomCol), roll: \(gameState.p2roll)")
            // Check if randomCol is within bounds
            if randomCol >= 0 && randomCol < gameState.p2board[0].count {
                // place opponent die
                if gameState.p2board[0][randomCol] == 0 {
                    gameState.p2board[0][randomCol] = gameState.p2roll
                } else if gameState.p2board[1][randomCol] == 0 {
                    gameState.p2board[1][randomCol] = gameState.p2roll
                } else if gameState.p2board[2][randomCol] == 0 {
                    gameState.p2board[2][randomCol] = gameState.p2roll
                }
            }
            
            // Calculate column sum
            let colNums = [gameState.p2board[0][randomCol], gameState.p2board[1][randomCol], gameState.p2board[2][randomCol]]
            gameState.p2score[randomCol] = calculateColSum(colNums: colNums)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // reset opponent animation
            opponentAnimation = "Ratau-idle"

            // player turn
            gameState.p2roll = -1
            gameState.isP1Turn = true
        }
        print(gameState.p2board)
        print("Exiting opponentTurn")
    }
    
    func resetGame() {
        isWhite = false
        isFlashing = false
        gameState.isP1Turn = true
        gameState.p1roll = -1
        gameState.p2roll = -1
        gameState.p1board = Array(repeating: Array(repeating: 0, count: 3), count: 3)
        gameState.p2board = Array(repeating: Array(repeating: 0, count: 3), count: 3)
        gameState.p1score = [0, 0, 0]
        gameState.p2score = [0, 0, 0]
        
        gameState.gamesPlayed += 1
        
        previewDieInCol[0] = -1
        previewDieInCol[1] = -1
        previewDieInCol[2] = -1
        
        // Small delay so app has time to reset state before exiting
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            gameState.gameInProgress = false
        }
    }

    @ViewBuilder
    func playerBoard(isOpponent: Bool) -> some View {
        VStack {
            if isOpponent == false {
                HStack {
                    ForEach(0..<3, id: \.self) { col in
//                        let colNums = [gameState.p1board[0][col], gameState.p1board[1][col], gameState.p1board[2][col]]
//                        let colSum = calculateColSum(colNums: colNums)
                        let colSum = isOpponent ? gameState.p2score[col] : gameState.p1score[col]
                        
                        Text("\(colSum)")
                            .font(Font.custom("Piazzolla", size: 16))
                            .fontWeight(.semibold)
                            .foregroundColor(Color("TextColor"))
                            .frame(width: 60)
                            .padding(.horizontal, 20)
                    }
                }
            }
            ZStack {
                // board
                VStack {
                    ForEach(0..<3, id: \.self) { row in
                        HStack {
                            ForEach(0..<3, id: \.self) { col in
                                // Reverse rows on opponent's board so they face the player
                                let reversedRow = isOpponent ? 2 - row : row
                                
                                let value = isOpponent ? gameState.p2board[reversedRow][col] : gameState.p1board[row][col]
                                
                                if value == 0 && isOpponent == false && gameState.p1roll != -1 && (previewDieInCol[col] == -1 || previewDieInCol[col] == row) {
                                    let imageName = "\(gameState.p1roll)_die"
                                    
                                    Image(imageName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60)
                                        .padding(.horizontal, 20)
                                        .opacity(isWhite ? 0.8 : 0.15)
                                        .onAppear {
                                            if !isFlashing {
                                                flash()
                                                isFlashing = true
                                            }
                                            previewDieInCol[col] = row
                                        }
                                } else {
                                    let is3match = threeInCol(col: col, isOpponent: isOpponent)
                                    let is2match = twoInCol(num: value, col: col, isOpponent: isOpponent)
                                    let imageName = "\(value)_die\(is3match ? "_blue" : (is2match ? "_yellow" : ""))"
                                    
                                    Image(imageName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60)
                                        .padding(.horizontal, 20)
                                }
                            }
                        }
                    }
                }
                
                if gameState.p1roll != -1 && isOpponent == false { // When player has a roll they have not placed
                    HStack {
                        ForEach(0..<3, id: \.self) { col in
                            if gameState.p1board[2][col] == 0 {
                                Color(.white)
                                    .frame(width: 60, height: 190)
                                    .padding(.horizontal, 20)
                                    .opacity(0.01)
                                    .onTapGesture {
                                        addDieToCol(col: col, die: gameState.p1roll)
                                        gameState.p1roll = -1
                                        gameState.isP1Turn = false
                                        previewDieInCol[0] = -1
                                        previewDieInCol[1] = -1
                                        previewDieInCol[2] = -1
                                        isFlashing = false
                                        
                                        // Update score
                                        let colNums = [gameState.p1board[0][col], gameState.p1board[1][col], gameState.p1board[2][col]]
                                        gameState.p1score[col] = calculateColSum(colNums: colNums)
                                        
                                        // if board is full, calculate winner
                                        if gameState.p1board[2][0] != 0 &&
                                            gameState.p1board[2][1] != 0 &&
                                            gameState.p1board[2][2] != 0
                                        {
                                            // TODO: Implement game winner screen
                                            print("game over")
                                            resetGame()
                                        } else {
                                            opponentTurn()
                                        }
                                    }
                            } else {
                                Color(.white)
                                    .frame(width: 80)
                                    .padding(.horizontal, 10)
                                    .opacity(.zero)
                                    .ignoresSafeArea()
                            }
                        }
                    }
                }
            }
            
            if isOpponent == true {
                HStack {
                    ForEach(0..<3, id: \.self) { col in
                        let colSum = gameState.p2board[0][col] + gameState.p2board[1][col] + gameState.p2board[2][col]
                        Text("\(colSum)")
                            .font(Font.custom("Piazzolla", size: 16))
                            .fontWeight(.semibold)
                            .foregroundColor(Color("TextColor"))
                            .frame(width: 60)
                            .padding(.horizontal, 20)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func inGameScreen() -> some View {
        VStack {
            opponentPanel()
            playerBoard(isOpponent: true)
            Spacer()
                .frame(height: 20)
            playerBoard(isOpponent: false)
            playerPanel()
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // Set the background to black
            
            VStack {
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

            if gameState.gameInProgress == false {
                landingScreen()
                    .padding()
            } else {
                inGameScreen()
                    .padding()
            }
        }
    }
}
