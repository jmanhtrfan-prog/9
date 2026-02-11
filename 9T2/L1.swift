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
    @State private var showKey = true
    @State private var showCard = false      
    var body: some View {
        ZStack {
            Color(red: 245/255, green: 235/255, blue: 220/255)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                    .frame(height: 80)
                
                Button(action: {
                }) {
                    Text("افتح الباب")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 139/255, green: 69/255, blue: 19/255))
                        .frame(width: 250, height: 70)
                        .background(
                            RoundedRectangle(cornerRadius: 35)
                                .fill(Color(red: 210/255, green: 190/255, blue: 160/255))
                        )
                        .shadow(color: .black.opacity(0.2), radius: 8)
                }
                
                ZStack {
                    Image(isHouseOpen ? "6" : "5")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 410, height: 450)
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
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                                            showCard = true
                                        }
                                    }
                                }) {
                                    Image("7")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .shadow(color: .black.opacity(0.3), radius: 5)
                                }
                            }
                            .padding(.trailing, 30)
                            .padding(.bottom, 30)
                        }
                        .frame(width: 400, height: 250)
                    }
                }
                Spacer()
            }
            VStack {
                HStack {
                    Button(action: {
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
            
            SettingsCardView(
                isPresented: $showSettings,
                isSoundEnabled: $isSoundEnabled,
                onReplay: {
                    withAnimation {
                        isHouseOpen = false
                        showKey = true
                        showCard = false
                    }
                }
            )
            
            if showCard {
                ZStack {
                    Color.black.opacity(0.1)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showCard = false
                            }
                        }
                    
                    Card7()  // 👈 حطي اسم الكارد اللي تبيه
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }
}

#Preview {
    LView()
        .previewInterfaceOrientation(.landscapeLeft)
}
