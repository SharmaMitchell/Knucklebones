//
//  GameView.swift
//  Knucklebones_Prototype
//
//  Created by Mitchell Sharma on 9/23/23.
//

import SwiftUI

struct GameView: View {
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
                    .aspectRatio(contentMode: .fit)
                Spacer()
                GIFImage(name: randomAnimation)
                    .frame(width: 245, height: 271)
                Spacer()
                Image("play_button")
                    .resizable()
                    .frame(width: 250, height: 60)
                    .padding(.all, 5)
                Image("difficulty_button")
                    .resizable()
                    .frame(width: 250, height: 60)
                    .padding(.all, 5)
                Spacer()
                    
            }

            .padding()
        }
    }
}
