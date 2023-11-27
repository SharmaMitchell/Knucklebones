//
//  RulesView.swift
//  Knucklebones_Prototype
//
//  Created by Mitchell Sharma on 9/23/23.
//

import SwiftUI

struct RulesView: View {
    // Determine if device is in vertical or horizontal orientation
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?

    // Game rules to be mapped in the ScrollView
    let rules = [
        "The game consists of two 3x3 boards. One belongs to you (the lamb), and the other belongs to your opponent.",
        "Each turn, you roll a 6-sided die, and must place it in a column on your board.",
        "If you place multiple dice of the same value in the same column, the score awarded for each of those dice is multiplied by the number of matching dice in that column.",
        "If you place a die of the same value as your opponents die in the same column, all matching dice in your opponent’s column are destroyed. You can use this mechanic to destroy your opponent’s high-scoring combos.",
        "The game ends when either player completely fills up their 3x3 board. The player with the higher score wins."
    ]

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

                ScrollView {
                    Text("Rules")
                        .font(Font.custom("Piazzolla", size: 36))
                        .fontWeight(.bold)
                        .foregroundColor(Color("TextColor"))
                    ForEach(rules, id: \.self) { rule in
                        Text(rule)
                            .font(Font.custom("Piazzolla", size: 16))
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(Color("TextColor"))
                            .padding(.horizontal, 4)
                            .padding(.bottom, 2)
                    }
                }.background {
                    Color(.black)
                        .opacity(0.75)

                }.cornerRadius(10)

                Spacer()
            }

            .padding()
        }
    }
}
