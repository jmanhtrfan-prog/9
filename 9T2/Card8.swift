//
//  Card8.swift
//  9T2
//
//  Created by Jumana on 19/08/1447 AH.
//

import SwiftUI

struct Card8: View {
    @EnvironmentObject var nav: GameNavigationManager 
    private let beige = Color(hex: "F5E6D3")
    private let darkBeige = Color(hex: "D4B896")
    private let brown = Color(hex: "8B4513")
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(beige)
                .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
            
            VStack(spacing: 50) {
                Text("مدائن صالح")        .font(.system(size: 30, weight: .bold))
                    .foregroundColor(brown)
                
                Text("مدائن صالح هي مدينة قديمة منحوتة وسط الجبال في مدينة العُلا، بناها الأنباط ببراعة، وهي أول مكان في السعودية تختاره منظمة اليونسكو ليكون موقعاً للتراث العالمي.")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .padding(.horizontal, 25)
                
                Button {
                    nav.nextStage()
                    // الأكشن هنا
                } label: {
                    Text("التالي")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(brown)
                        .frame(width: 150, height: 50)
                        .background(
                            Capsule()
                                .fill(darkBeige)
                        )
                }
                .padding(.top, 10)
            }
            .padding(.vertical, 25)
        }
        .frame(width: 320, height: 450)
    }
}

#Preview {
    Card8()
}
