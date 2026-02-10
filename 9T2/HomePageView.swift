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
                    HStack {
                        topBarButton(systemName: "person.fill")
                        Spacer()
                        topBarButton(systemName: "gearshape.fill")
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, geometry.safeAreaInsets.top > 0 ? 10 : 40)
                    
                    Spacer()
                    if !hasStarted {
                        Button(action: {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                hasStarted = true
                            }
                        }) {
                            Text("ابدأ")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 200, height: 60)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Color(red: 1.0, green: 0.8, blue: 0.0))
                                )
                                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                        }
                        .padding(.bottom, 100)
                    }
                    Spacer()
                        .frame(height: geometry.safeAreaInsets.bottom + 20)
                }
            }
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Helper Components
    private func topBarButton(systemName: String) -> some View {
        Button(action: { /* Action */ }) {
            Circle()
                .fill(Color(red: 1.0, green: 0.85, blue: 0.4))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: systemName)
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                )
        }
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

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}

