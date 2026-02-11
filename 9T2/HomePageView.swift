//
//  HomePageView.swift
//  9T2
//
//  Created by Rahaf on 10/02/2026.
//
import SwiftUI

struct HomePageView: View {
    // MARK: - Game State
    @State private var hasStarted: Bool = false
    @State private var currentLevel: Int = 1
    @State private var completedLevels: Set<Int> = []
    @State private var currentRegion: Int = 1
    @State private var showSettings = false  // 🔧 للإعدادات
    @State private var isSoundEnabled = true  // 🔊 للصوت
    
    var body: some View {
       
        GeometryReader { geometry in
            ZStack {
                Image(currentRegion == 1 ? "saudi_map" : "saudi_map2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .ignoresSafeArea()
                    .onTapGesture {
                        if hasStarted {
                            completeCurrentLevel()
                        }
                    }

                if currentRegion == 1 {
                    Image("najd_finished_overlay")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .ignoresSafeArea()
                        .opacity(completedLevels.count >= 5 ? 1.0 : 0.0)
                        .animation(.easeIn(duration: 0.8), value: completedLevels.count)
                }
                
                VStack(spacing: 0) {
                    // زر الإعدادات فقط (بدون زر الشخص)
                    HStack {
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
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, geometry.safeAreaInsets.top > 0 ? 10 : 30)
                    
                    Spacer()
                    
                    if !hasStarted {
                        Button(action: {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                hasStarted = true
                            }
                        }) {
                            Text("ابدأ")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Color(red: 139/255, green: 69/255, blue: 19/255))  // 🎨 نفس لون الأزرار
                                .frame(width: 200, height: 60)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Color(red: 210/255, green: 190/255, blue: 160/255))  // 🎨 نفس لون الأزرار
                                )
                                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                        }
                        .padding(.bottom, 100)
                    }
                    
                    Spacer()
                        .frame(height: geometry.safeAreaInsets.bottom + 20)
                }
                
                // كارد الإعدادات
                SettingsCardView(
                    isPresented: $showSettings,
                    isSoundEnabled: $isSoundEnabled,  // 🔊 ربط الصوت
                    onReplay: {
                        // إعادة اللعبة
                        hasStarted = false
                        currentLevel = 1
                        completedLevels = []
                    }
                )
            }
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Game Logic
    func completeCurrentLevel() {
        withAnimation {
            if currentLevel <= 5 {
                completedLevels.insert(currentLevel)
                if currentLevel < 5 {
                    currentLevel += 1
                }
            }
        }
    }
}

#Preview {
    HomePageView()
}
