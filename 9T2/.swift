//
//  Untitled.swift
//  9T2
//
//  Created by Jumana on 14/08/1447 AH.
//

import SwiftUI
struct HView: View {
    var body: some View {
        ZStack {
            Color(red: 245/255, green: 235/255, blue: 220/255)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Image("H")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 80)
                    .clipped()
                
                PuzzleGameView(imageName: "3")
                Image("H")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 80)
                    .clipped()
            }
            .ignoresSafeArea()
        }
    }
}
#Preview {
    HView()
       
}
