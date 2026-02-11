//
//  Card2.swift
//  9T2
//
//  Created by Jumana on 19/08/1447 AH.
//

import SwiftUI

struct Card2: View {
    private let beige = Color(hex: "F5E6D3")
    private let darkBeige = Color(hex: "D4B896")
    private let brown = Color(hex: "8B4513")
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(beige)
                .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
            
            VStack(spacing: 50) {
                Text(" العرضه النجديه ")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(brown)
                
                Text("العرضة رقصة تراثية جماعية تبدأ بالشاعر الذي يلقي أبيات الحماسة، ثم ترددها الصفوف بصوت واحد مع حركات منتظمة بالسيوف، بينما تضبط الطبول الإيقاع وتحدد سرعة الأداء، ويقوم قائد الصف بتنظيم المشاركين وتوحيد الحركة والتوقيت. ")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .padding(.horizontal, 25)
                
                Button {
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
    Card2()
}
