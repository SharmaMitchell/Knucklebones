//
//  StatsView.swift
//  Knucklebones_Prototype
//
//  Created by Mitchell Sharma on 9/23/23.
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject private var gameState: GameState

    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?

    @ViewBuilder
    func rollStats(die: Int) -> some View {
        let imageName = "\(die + 1)_die"
        let dieSize: CGFloat = verticalSizeClass == .regular ? 60 : 30
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: dieSize, height: dieSize)
                .padding(.horizontal, 20)
            Text("\(gameState.rolls[die])")
                .font(Font.custom("Piazzolla", size: 20))
                .fontWeight(.bold)
                .foregroundColor(Color("TextColor"))
        }
    }

    @ViewBuilder
    func totalRolls() -> some View {
        VStack {
            Text("Total Rolls")
                .font(Font.custom("Piazzolla", size: 20))
                .fontWeight(.bold)
                .foregroundColor(Color("TextColor"))
            VStack {
                HStack {
                    rollStats(die: 0)
                    rollStats(die: 1)
                    rollStats(die: 2)
                }
                HStack {
                    rollStats(die: 3)
                    rollStats(die: 4)
                    rollStats(die: 5)
                }
            }
        }
    }

    @ViewBuilder
    func totalWins() -> some View {
        VStack {
            Text("Total Wins")
                .font(Font.custom("Piazzolla", size: 20))
                .fontWeight(.bold)
                .foregroundColor(Color("TextColor"))

            HStack {
                Image("lamb_profile_image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .padding(.horizontal, 20)

                VStack {
                    HStack {
                        Text("Games Won")
                            .font(Font.custom("Piazzolla", size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(Color("TextColor"))
                            .frame(maxWidth: 150, alignment: .leading)

                        Text("\(gameState.gamesWon)")
                            .font(Font.custom("Piazzolla", size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(Color("TextColor"))
                            .frame(maxWidth: 50, alignment: .trailing)
                    }
                    Spacer()
                        .frame(height: 20)
                    HStack {
                        Text("Games Played")
                            .font(Font.custom("Piazzolla", size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(Color("TextColor"))
                            .frame(maxWidth: 150, alignment: .leading)

                        Text("\(gameState.gamesPlayed)")
                            .font(Font.custom("Piazzolla", size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(Color("TextColor"))
                            .frame(maxWidth: 50, alignment: .trailing)
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

            Color.pink.opacity(0.075)
                .edgesIgnoringSafeArea(.all)

            VStack {
                if verticalSizeClass == .regular {
                    Image("knucklebones")
                        .resizable()
                        .frame(width: 353, height: 136)
                } else {
                    Image("knucklebones")
                        .resizable()
                        .frame(width: 235, height: 90)
                }
                Spacer()

                ScrollView {
                    if verticalSizeClass == .regular {
                        Text("Statistics")
                            .font(Font.custom("Piazzolla", size: 36))
                            .fontWeight(.bold)
                            .foregroundColor(Color("TextColor"))
                            .padding(.bottom, 4)

                        totalRolls()

                        Divider()
                            .overlay(Color("TextColor"))

                        totalWins()
                    } else {
                        HStack(alignment: .top) {
                            Spacer()
                            totalRolls()

                            Divider()
                                .overlay(Color("TextColor"))

                            totalWins()
                            Spacer()
                        }
                    }
                }

                Spacer()
            }

            .padding()
        }
    }
}
