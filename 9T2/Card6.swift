//
//  Card6.swift
//  9T2
//
//  Created by Jumana on 19/08/1447 AH.
//

import SwiftUI

struct Card6: View {
    private let beige = Color(hex: "F5E6D3")
    private let darkBeige = Color(hex: "D4B896")
    private let brown = Color(hex: "8B4513")
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(beige)
                .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
            
            VStack {
                Text("لو عرفوا حلاوة هرجته\nما عيروني بعرجته")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(brown)
                    .multilineTextAlignment(.center)
                    .padding(.top, 30)

                Spacer(minLength: 40)

                Text("يُقال عن شخص فيه عيب بسيط، لكن طيبته أو جماله تغطي عليه. المعنى: لا نحكم على الناس من ظاهرهم، فالعيوب أحياناً تخفي جمال أكبر.")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.black.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .padding(.horizontal, 25)

                Spacer(minLength: 20)

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
                .padding(.bottom, 10)
            }
            .padding(.vertical, 20)
        }
        .frame(width: 320, height: 450)
    }
}

#Preview {
    Card6()
}
