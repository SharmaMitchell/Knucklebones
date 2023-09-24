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
            
            VStack {
                Image("knucklebones")
                    .resizable()
                    .frame(width: 353, height: 136)
                Spacer()
                
                Spacer()
                    
            }

            .padding()
        }
    }
}
