//
//  StatsView.swift
//  Knucklebones_Prototype
//
//  Created by Mitchell Sharma on 9/23/23.
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject private var gameState: GameState

    let lambAnimations = ["Lamb-dance", "Lamb-evil"]
    var randomAnimation: String {
        return lambAnimations.randomElement() ?? ""
    }

    @ViewBuilder
    func rollStats(die: Int) -> some View {
        let imageName = "\(die + 1)_die"
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .padding(.horizontal, 20)
            Text("\(gameState.rolls[die])")
                .font(Font.custom("Piazzolla", size: 20))
                .fontWeight(.bold)
                .foregroundColor(Color("TextColor"))
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
                Image("knucklebones")
                    .resizable()
                    .frame(width: 353, height: 136)
                Spacer()
                Text("Statistics")
                    .font(Font.custom("Piazzolla", size: 36))
                    .fontWeight(.bold)
                    .foregroundColor(Color("TextColor"))
                    .padding(.bottom, 4)
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

                Divider()
                    .overlay(Color("TextColor"))

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
                                .frame(maxWidth: .infinity, alignment: .leading)

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
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("\(gameState.gamesPlayed)")
                                .font(Font.custom("Piazzolla", size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(Color("TextColor"))
                                .frame(maxWidth: 50, alignment: .trailing)
                        }
                    }
                }

                Spacer()
            }

            .padding()
        }
    }
}
