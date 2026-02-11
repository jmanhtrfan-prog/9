//
//  Card10.swift
//  9T2
//
//  Created by Jumana on 19/08/1447 AH.
//

import SwiftUI

struct Card10: View {
    @EnvironmentObject var nav: GameNavigationManager 
    private let beige = Color(hex: "F5E6D3")
    private let darkBeige = Color(hex: "D4B896")
    private let brown = Color(hex: "8B4513")
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(beige)
                .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
            
            VStack {
                Text("الزبون")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(brown)
                    .multilineTextAlignment(.center)
                    .padding(.top, 30)

                Spacer(minLength: 40)
                
                Text("الزبون الحجازي هو رداء تراثي فخم للمناسبات، يتميز بقصة طويلة وتطريزات ذهبية (قصب) على الصدر والأكمام,يُصنع من الحرير أو القز الفاخر، وفي الشتاء من الأصواف، ويُلبس عادةً فوق قطعة داخلية تسمى المحرمة,يُعتبر رمزاً للأناقة الحجازية التقليدية ويتكون طقمه الكامل من ثلاث قطع تشمل غطاء الرأس.")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.black.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .padding(.horizontal, 25)

                Spacer(minLength: 20)

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
                .padding(.bottom, 10)
            }
            .padding(.vertical, 20)
        }
        .frame(width: 320, height: 580)
    }
}

#Preview {
    Card10()
}
