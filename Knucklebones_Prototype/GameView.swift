//
//  GameView.swift
//  Knucklebones_Prototype
//
//  Created by Mitchell Sharma on 9/23/23.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject private var gameState: GameState
    
    // Determine if device is in vertical or horizontal orientation
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    
    // TODO: Add Normal difficulty, use Derp animation for easy mode
    @State private var showingDifficulty = false
    let difficultyOptions = ["Easy", "Hard"]
    
    // Lamb animation for home screen (evil animation on hard difficulty)
    let lambAnimations = ["Lamb-dance", "Lamb-evil"]
    var currentAnimation: String {
        let animationIndex = difficultyOptions.firstIndex(of: gameState.gameDifficulty)!
        return lambAnimations[animationIndex]
    }
    
    // Opacity logic for die placement
    @State private var isWhite = false // Toggled every x seconds for flashing animation
    @State private var isFlashing = false // Flashing animation on/off
    // Track the row of preview dice in each column (-1 means no preview die in col)
    @State private var previewDieInCol: [Int] = [-1, -1, -1]
    
    // Opponent animation for opponent panel
    @State private var opponentAnimation = "Ratau-idle"
    
    /**
     Play and Difficulty buttons displayed on landing screen
     */
    @ViewBuilder
    func landingScreenButtons() -> some View {
        VStack {
            Image("play_button")
                .resizable()
                .frame(width: 250, height: 80)
                .padding(.all, 5)
                .onTapGesture {
                    withAnimation {
                        gameState.gameInProgress = true
                    }
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
        }
    }
    
    /**
     Landing Screen with logo, lamb animation, and buttons
     */
    @ViewBuilder
    func landingScreen() -> some View {
        if verticalSizeClass == .regular {
            VStack {
                Image("knucklebones")
                    .resizable()
                    .frame(width: 353, height: 136)
                Spacer()
                GIFImage(name: currentAnimation)
                    .frame(width: 245, height: 271)
                Spacer()
                landingScreenButtons()
                Spacer()
            }
        } else {
            VStack {
                Image("knucklebones")
                    .resizable()
                    .frame(width: 353, height: 136)
                Spacer()
                HStack {
                    Spacer()
                    GIFImage(name: currentAnimation)
                        .frame(width: 200, height: 200)
                    Spacer()
                    landingScreenButtons()
                    Spacer()
                }
            }
        }
    }
    
    /**
     Opponent panel displaying opponent animation, name, and score
     */
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
        }
    }
    
    /**
     Player panel displaying name (The Lamb), score, and buttons (quit and roll)
     */
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
                        resetGame(playAgain: false)
                    }
                
                Spacer()
                    .frame(width: 60)
                
                Image("roll_button_2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 110, height: 60)
                    .onTapGesture {
                        if gameState.isP1Turn && gameState.p1roll == -1 {
                            rollDie(isOpponent: false)
                        }
                    }
            }
        }
    }
    
    /**
     Roll player or opponent die, set gameState to the roll value
     */
    func rollDie(isOpponent: Bool) {
        let randomRoll = Int.random(in: 1 ... 6)
        if isOpponent == true {
            gameState.p2roll = randomRoll
            return
        }
        gameState.p1roll = randomRoll
        gameState.rolls[randomRoll - 1] += 1
    }
    
    /**
     Add die to player column (add to first available space)
     */
    func addDieToCol(col: Int, die: Int) {
        for i in 0..<3 {
            if gameState.p1board[i][col] == 0 {
                gameState.p1board[i][col] = die
                return
            }
        }
    }
    
    /**
     Flashing animation for player's die placement: toggle isWhite every 0.75 seconds
     */
    func flash() {
        withAnimation(Animation.easeInOut(duration: 0.75).repeatForever()) {
            isWhite.toggle()
        }
    }
    
    /**
     Determine if there are 2 of the same value in a given column (for matching dice colors)
     */
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
    
    /**
     Determine if there are 3 of the same value in a given column (for matching dice colors)
     */
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
    
    /**
     Calculate column sums (called upon die placement in a given column)
     */
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
            print("\(colNums[0]) != \(colNums[1]) != \(colNums[2])")
            return colNums.reduce(0, +)
        }
    }
    
    /**
     Opponent turn logic.
        - Play opponent rolling animation
        - Roll die
        - Choose column (randomly on easy mode, strategically on hard mode)
        - Place die in chosen column
        - Remove matching player dice (in same column on player board)
        - Shift down any player dice that were above removed dice
        - Calculate scores opponent score
        - Calculate player score (to update if any dice were removed)
        - Calculate winner if board is full after die placement
     */
    func opponentTurn() {
        opponentAnimation = "Ratau-roll"
        rollDie(isOpponent: true)
        var possibleCols = [0, 1, 2]
        for i in 0..<3 {
            if gameState.p2board[2][i] != 0 {
                possibleCols.removeAll(where: { $0 == i })
            }
        }
        var dieCol = possibleCols.randomElement() ?? -1
        if dieCol == -1 || possibleCols.count == 0 {
            return
        }
        
        // chose dieCol strategically if difficulty is on hard
        if gameState.gameDifficulty == "Hard" {
            // Prioritize combos
            outerLoop: for col in possibleCols {
                for row in 0..<3 {
                    if gameState.p2board[row][col] == gameState.p2roll {
                        dieCol = col
                        break outerLoop
                    }
                }
            }
            
            // Look for opportunities to destroy player dice
            outerLoop: for col in possibleCols {
                for row in 0..<3 {
                    if gameState.p1board[row][col] == gameState.p2roll {
                        dieCol = col
                        break outerLoop
                    }
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Check if randomCol is within bounds
            if dieCol >= 0 && dieCol < gameState.p2board[0].count {
                // place opponent die
                if gameState.p2board[0][dieCol] == 0 {
                    gameState.p2board[0][dieCol] = gameState.p2roll
                } else if gameState.p2board[1][dieCol] == 0 {
                    gameState.p2board[1][dieCol] = gameState.p2roll
                } else if gameState.p2board[2][dieCol] == 0 {
                    gameState.p2board[2][dieCol] = gameState.p2roll
                } else {
                    print("Error: Impossible opponent col selected: \(dieCol)")
                    return
                }
                
                // Remove matching player dice
                for i in stride(from: 2, through: 0, by: -1) {
                    if gameState.p1board[i][dieCol] == gameState.p2roll {
                        withAnimation {
                            gameState.p1board[i][dieCol] = 0
                        }
                        
                        // shift any dice above the removed die
                        if i < 2 && gameState.p1board[i + 1][dieCol] != 0 {
                            gameState.p1board[i][dieCol] = gameState.p1board[i + 1][dieCol]
                            gameState.p1board[i + 1][dieCol] = 0
                        }
                        
                        // handle die at end of column
                        if i == 0 && gameState.p1board[2][dieCol] != 0 {
                            gameState.p1board[1][dieCol] = gameState.p1board[2][dieCol]
                            gameState.p1board[2][dieCol] = 0
                        }
                    }
                }
            }
            
            // Calculate scores
            let colNums = [gameState.p2board[0][dieCol], gameState.p2board[1][dieCol], gameState.p2board[2][dieCol]]
            gameState.p2score[dieCol] = calculateColSum(colNums: colNums)
            
            let playerColNums = [gameState.p1board[0][dieCol], gameState.p1board[1][dieCol], gameState.p1board[2][dieCol]]
            gameState.p1score[dieCol] = calculateColSum(colNums: playerColNums)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // reset opponent animation
            opponentAnimation = "Ratau-idle"
            
            // if board full, calculate game winner
            if gameState.p2board[2][0] != 0 &&
                gameState.p2board[2][1] != 0 &&
                gameState.p2board[2][2] != 0
            {
                if gameState.p1score.reduce(0, +) > gameState.p2score.reduce(0, +) {
                    // player won
                    gameState.gamesWon += 1
                    withAnimation {
                        gameState.winner = WinnerType.p1
                    }
                } else {
                    // opponent won
                    withAnimation {
                        gameState.winner = WinnerType.p2
                    }
                }
            } else {
                // player turn
                gameState.p2roll = -1
                gameState.isP1Turn = true
            }
        }
    }
    
    /**
     Reset game state upon game quit
     */
    func resetGame(playAgain: Bool) {
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
        
        gameState.winner = nil
        
        if !playAgain {
            // Small delay so app has time to reset state before exiting
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                withAnimation {
                    gameState.gameInProgress = false
                }
            }
        }
    }

    /**
     Board for player and opponent:
        - Display dice (including colored dice for matching dice in the same column)
        - Display scores from each column
        - After player rolls a die:
            - Display the die in all possible columns with reduced opacity
            - Animate the opacity of the example die placements
            - On tap, place the die in the corresponding column
        - On die removal, flash red
            - Dice are given a red background such that upon removal with animation they fade to red before fading out entirely
     */
    @ViewBuilder
    func playerBoard(isOpponent: Bool) -> some View {
        VStack {
            if isOpponent == false && gameState.winner == nil {
                HStack {
                    ForEach(0..<3, id: \.self) { col in
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
                                        .background {
                                            // TODO: Don't shift dice until removal animation over
                                            // (Add delay after die removal before shifting)
                                            if !isOpponent {
                                                Color("AccentColor")
                                                    .cornerRadius(5)
                                                    .opacity(
                                                        gameState.p1board[row][col] != 0 ? 1 : 0
                                                    )
                                            } else {
                                                Color("AccentColor")
                                                    .cornerRadius(5)
                                                    .opacity(
                                                        gameState.p2board[reversedRow][col] != 0 ? 1 : 0
                                                    )
                                            }
                                        }
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
                                        
                                        // Remove matching dice from opponent column
                                        for i in stride(from: 2, through: 0, by: -1) {
                                            if gameState.p2board[i][col] == gameState.p1roll {
                                                withAnimation {
                                                    gameState.p2board[i][col] = 0
                                                }
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                    // shift any dice above the removed die
                                                    if i < 2 && gameState.p2board[i + 1][col] != 0 {
                                                        gameState.p2board[i][col] = gameState.p2board[i + 1][col]
                                                        gameState.p2board[i + 1][col] = 0
                                                    }
                                                    
                                                    // handle die at end of column
                                                    if i == 0 && gameState.p2board[2][col] != 0 {
                                                        gameState.p2board[1][col] = gameState.p2board[2][col]
                                                        gameState.p2board[2][col] = 0
                                                    }
                                                }
                                            }
                                        }
                                        
                                        gameState.p1roll = -1
                                        gameState.isP1Turn = false
                                        previewDieInCol[0] = -1
                                        previewDieInCol[1] = -1
                                        previewDieInCol[2] = -1
                                        isFlashing = false
                                        
                                        // Update score
                                        let colNums = [gameState.p1board[0][col], gameState.p1board[1][col], gameState.p1board[2][col]]
                                        gameState.p1score[col] = calculateColSum(colNums: colNums)
                                        
                                        let oppColNums = [gameState.p2board[0][col], gameState.p2board[1][col], gameState.p2board[2][col]]
                                        gameState.p2score[col] = calculateColSum(colNums: oppColNums)
                                        
                                        // if board is full, calculate winner
                                        if gameState.p1board[2][0] != 0 &&
                                            gameState.p1board[2][1] != 0 &&
                                            gameState.p1board[2][2] != 0
                                        {
                                            if gameState.p1score.reduce(0, +) > gameState.p2score.reduce(0, +) {
                                                // player won
                                                gameState.gamesWon += 1
                                                withAnimation {
                                                    gameState.winner = WinnerType.p1
                                                }
                                            } else {
                                                // opponent won
                                                withAnimation {
                                                    gameState.winner = WinnerType.p2
                                                }
                                            }
                                        } else {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                opponentTurn()
                                            }
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
            
            if isOpponent == true && gameState.winner == nil {
                HStack {
                    ForEach(0..<3, id: \.self) { col in
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
        }
    }
    
    /**
     Main game view displaying boards, scores, player panels, and winner panels (upon game over)
     */
    @ViewBuilder
    func inGameScreen() -> some View {
        if verticalSizeClass == .regular {
            VStack {
                if gameState.winner == nil {
                    opponentPanel()
                }
                    
                playerBoard(isOpponent: true)
                Spacer()
                    .frame(height: 20)
                playerBoard(isOpponent: false)
                if gameState.winner == nil {
                    playerPanel()
                }
                    
                if gameState.winner != nil {
                    Text("\(gameState.winner == WinnerType.p1 ? "The Lamb" : "Ratau") Wins!")
                        .font(Font.custom("Piazzolla", size: 26))
                        .fontWeight(.bold)
                        .foregroundColor(Color("TextColor"))
                    HStack {
                        Spacer()
                        GIFImage(name: gameState.winner == WinnerType.p1
                            ? "Lamb-win-loop"
                            : "Lamb-lose-loop")
                            .frame(width: 70, height: 70)
                        Spacer()
                        GIFImage(name: gameState.winner == WinnerType.p2
                            ? "Ratau-win-loop"
                            : "Ratau-lose-loop")
                            .frame(width: 70, height: 70)
                        Spacer()
                    }
                    Text("\(gameState.p1score.reduce(0, +))    -    \(gameState.p2score.reduce(0, +))")
                        .font(Font.custom("Piazzolla", size: 26))
                        .fontWeight(.bold)
                        .foregroundColor(Color("TextColor"))
                    HStack {
                        Image("quit_button")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 110, height: 60)
                            .onTapGesture {
                                resetGame(playAgain: false)
                            }

                        Image("play_button_small")
                            .resizable()
                            .frame(width: 170, height: 60)
                            .padding(.all, 5)
                            .onTapGesture {
                                resetGame(playAgain: true)
                            }
                    }
                }
            }
            
        } else {
            HStack {
                VStack {
                    if gameState.winner == nil {
                        opponentPanel()
                    }
                    
                    playerBoard(isOpponent: true)
                    
                    if gameState.winner != nil {
                        Text("\(gameState.winner == WinnerType.p1 ? "The Lamb" : "Ratau") Wins!")
                            .font(Font.custom("Piazzolla", size: 26))
                            .fontWeight(.bold)
                            .foregroundColor(Color("TextColor"))
                        Text("\(gameState.p1score.reduce(0, +))    -    \(gameState.p2score.reduce(0, +))")
                            .font(Font.custom("Piazzolla", size: 26))
                            .fontWeight(.bold)
                            .foregroundColor(Color("TextColor"))
                    }
                }
                
                Spacer()
                    .frame(width: 20)
                VStack {
                    playerBoard(isOpponent: false)
                    
                    if gameState.winner == nil {
                        playerPanel()
                    }
                    
                    if gameState.winner != nil {
                        HStack {
                            Image("quit_button")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 110, height: 60)
                                .onTapGesture {
                                    resetGame(playAgain: false)
                                }

                            Image("play_button_small")
                                .resizable()
                                .frame(width: 170, height: 60)
                                .padding(.all, 5)
                                .onTapGesture {
                                    resetGame(playAgain: true)
                                }
                        }
                    }
                }
            }
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
            
            VStack {
                if !gameState.gameInProgress {
                    LinearGradient(gradient: Gradient(colors: [Color.pink.opacity(0.2), Color.pink.opacity(0.075)]),
                                   startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all)
                } else {
                    LinearGradient(gradient: Gradient(colors: [Color.pink.opacity(0.075), Color.pink.opacity(0.075)]),
                                   startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all)
                }
            }.animation(.easeOut, value: 0)
            
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
