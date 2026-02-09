//
//  L1.swift
//  9T2
//
//  Created by Jumana on 20/08/1447 AH.
//

import SwiftUI

struct LView: View {
    @State private var showSettings = false
    @State private var isSoundEnabled = true
    @State private var isHouseOpen = false 
    @State private var showKey = true  // 🔑 إظهار المفتاح
    
    var body: some View {
        ZStack {
            // الخلفية البيج
            Color(red: 245/255, green: 235/255, blue: 220/255)
                .ignoresSafeArea()
            
            // 🏠 البيت والمفتاح
            VStack {
                Spacer()
                
                ZStack {
                    // صورة البيت (مقفل أو مفتوح)
                    Image(isHouseOpen ? "6" : "5")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 410, height: 450)  // كبّرت البيت
                    
                    // 🔑 المفتاح (تحت في الزاوية)
                    if showKey {
                        VStack {
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                        isHouseOpen = true
                                        showKey = false
                                    }
                                }) {
                                    Image("7")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)  // صغّرت المفتاح
                                        .shadow(color: .black.opacity(0.3), radius: 5)
                                }
                            }
                            .padding(.trailing, 30)
                            .padding(.bottom, 30)  // نزّلت المفتاح تحت
                        }
                        .frame(width: 400, height: 250)
                    }
                }
                
                Spacer()
            }
            
            // الأزرار (رجوع وإعدادات)
            VStack {
                HStack {
                    // زر الرجوع
                    Button(action: {
                        // أكشن الرجوع
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(Color(red: 200/255, green: 170/255, blue: 140/255))
                            
                            Text("رجوع")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Color(red: 200/255, green: 170/255, blue: 140/255))
                        }
                    }
                    .padding(.leading, 30)
                    .padding(.top, -10)
                    
                    Spacer()
                    
                    // زر الإعدادات
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showSettings = true
                        }
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 28))
                            .foregroundColor(Color(red: 200/255, green: 170/255, blue: 140/255))
                            .frame(width: 55, height: 55)
                    }
                    .padding(.trailing, 30)
                    .padding(.top, -10)
                }
                
                Spacer()
            }
            
            // كارد الإعدادات
            SettingsCardView(
                isPresented: $showSettings,
                isSoundEnabled: $isSoundEnabled,
                onReplay: {
                    // إعادة اللعبة - البيت يرجع مقفل
                    withAnimation {
                        isHouseOpen = false
                        showKey = true
                    }
                }
            )
        }
    }
}

#Preview {
    LView()
        .previewInterfaceOrientation(.landscapeLeft)
}
