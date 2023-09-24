//
//  RulesView.swift
//  Knucklebones_Prototype
//
//  Created by Mitchell Sharma on 9/23/23.
//

import SwiftUI

struct RulesView: View {
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
                    .frame(height: 200)
                Image("eyes_bottom")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            VStack {
                Image("knucklebones")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Spacer()
                GIFImage(name: randomAnimation)
                    .frame(width: 245, height: 271)
                Spacer()
                Text("Play")
                    .foregroundColor(.white)
                    .padding(.all, 10)
                Text("Difficulty")
                    .foregroundColor(.white)
                    .padding(.all, 10)
                Spacer()
                    
            }

            .padding()
        }
    }
}
