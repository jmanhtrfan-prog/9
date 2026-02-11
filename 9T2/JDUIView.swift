//
//  JDUIView.swift
//  9T2
//
//  Created by Jumana on 22/08/1447 AH.
//

import SwiftUI

struct JDUIView: View {
    @State private var currentLevelIndex = 0
    @State private var showAlert = false
    @State private var isCorrect = false
    @State private var score = 0
    @State private var levels: [GameLevel]
    @State private var currentDisplayedNames: [String] = []
    @State private var isReverting: Bool = false
    @State private var showCard = false  // 🎴 لإظهار الكارد

    @State private var showSettings = false
    @State private var isSoundEnabled = true
    @Environment(\.presentationMode) var presentationMode

    init() {
        let allLevels: [GameLevel] = [
            GameLevel(
                baseImageNames: ["t1", "123", "33"],
                revealImageNames: ["tt", "1231", "44"],
                tapToRevealMap: [0, 1, 2],
                correctSlotIndex: 0
            ),

            GameLevel(
                baseImageNames: ["t1", "123", "33"],
                revealImageNames: ["tt", "1231", "44"],
                tapToRevealMap: [0, 1, 2],
                correctSlotIndex: 0
            ),

            GameLevel(
                baseImageNames: ["t1", "123", "33"],
                revealImageNames: ["tt", "1231", "44"],
                tapToRevealMap: [0, 1, 2],
                correctSlotIndex: 0
            )
        ]

        _levels = State(initialValue: allLevels)
        _currentDisplayedNames = State(initialValue: allLevels.first?.baseImageNames ?? [])
    }

    var body: some View {
        ZStack {
            Color(red: 245/255, green: 235/255, blue: 220/255)
                .ignoresSafeArea()

            VStack {
                Spacer().frame(height: 20)

                if currentLevelIndex < levels.count {

                    ZStack {
                        VStack(spacing: 20) {
                            Spacer()
                                .frame(height: 70)
                            
                            Text("لو عرفوا حلاوة هرجته ما عيروني بعرجته")
                                .font(.system(size: 23, weight: .bold))
                                .foregroundColor(Color(red: 139/255, green: 69/255, blue: 19/255))
                                .multilineTextAlignment(.center)
                                .frame(width: 300, height: 70, alignment: .center)
                                .background(
                                    RoundedRectangle(cornerRadius: 35)
                                        .fill(Color(red: 210/255, green: 190/255, blue: 160/255))
                                )
                                .shadow(color: .black.opacity(0.2), radius: 8)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.horizontal, 16)

                            ZStack {
                                GeometryReader { geo in
                                    let count = 3
                                    HStack(spacing: 0) {
                                        ForEach(0..<count, id: \.self) { idx in
                                            let names = currentDisplayedNames
                                            let name = idx < names.count ? names[idx] : ""
                                            Image(name)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: geo.size.width / CGFloat(count), height: geo.size.height)
                                        }
                                    }
                                }
                                .frame(maxHeight: 500)
                                .padding(.horizontal, 10)
                                .opacity(1)

                                GeometryReader { geo in
                                    let count = 3
                                    HStack(spacing: 0) {
                                        ForEach(0..<count, id: \.self) { slot in
                                            Rectangle()
                                                .fill(Color.clear)
                                                .contentShape(Rectangle())
                                                .frame(
                                                    width: geo.size.width / CGFloat(count),
                                                    height: geo.size.height
                                                )
                                                .onTapGesture {
                                                    if !isReverting {
                                                        handleSlotTap(slotIndex: slot)
                                                    }
                                                }
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                    }

                }

                Spacer()
            }

            VStack {
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
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
                    .opacity(1)

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
                    .opacity(1)
                }

                Spacer()
            }
            
            // ✅ الإعدادات مع إعادة اللعب
            SettingsCardView(
                isPresented: $showSettings,
                isSoundEnabled: $isSoundEnabled,
                onReplay: {
                    restartGame()  // 👈 الحل! تنادي الدالة
                }
            )
            
            // 🎴 الكارد (يظهر بعد الإجابة الصحيحة)
            if showCard {
                ZStack {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showCard = false
                            }
                        }
                    
                    Card6()
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .navigationBarHidden(true)
    }

    func handleSlotTap(slotIndex: Int) {
        let level = levels[currentLevelIndex]

        if slotIndex == level.correctSlotIndex {
            currentDisplayedNames = level.revealImageNames
            isCorrect = true
            score += 10
            
            // 🎴 يطلع الكارد مباشرة (بدون انتظار)
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showCard = true
            }
            
            showAlert = true
            return
        }

        let revealIndex = level.tapToRevealMap[slotIndex]
        var updated = currentDisplayedNames
        if slotIndex < updated.count && revealIndex < level.revealImageNames.count {
            isReverting = true
            let originalName = levels[currentLevelIndex].baseImageNames[slotIndex]
            updated[slotIndex] = level.revealImageNames[revealIndex]
            currentDisplayedNames = updated

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                var revert = currentDisplayedNames
                if slotIndex < revert.count {
                    revert[slotIndex] = originalName
                    currentDisplayedNames = revert
                }
                isReverting = false
            }
        }

        isCorrect = false
        if score > 0 { score -= 2 }
        showAlert = true
    }

    func nextLevel() {
        currentLevelIndex += 1
        if currentLevelIndex >= levels.count {
            currentLevelIndex = 0
            score = 0
            isCorrect = false
            levels = levels.shuffled()
        }
        currentDisplayedNames = levels[currentLevelIndex].baseImageNames
    }

    func restartGame() {
        currentLevelIndex = 0
        score = 0
        isCorrect = false
        showCard = false  // 🎴 يخفي الكارد
        levels = levels.shuffled()
        currentDisplayedNames = levels.first?.baseImageNames ?? []
    }
}

struct GameLevel {
    let baseImageNames: [String]
    let revealImageNames: [String]
    let tapToRevealMap: [Int]
    let correctSlotIndex: Int
}

#Preview {
    JDUIView()
}
