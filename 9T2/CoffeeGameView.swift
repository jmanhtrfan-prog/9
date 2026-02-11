//
//  CoffeeGameView.swift
//  9T2
//
//  Created by Rahaf on 10/02/2026.
//
import SwiftUI

struct CoffeeGameView: View {
    @StateObject private var viewModel = CoffeeGameViewModel()
    @State private var showSettings = false
    @State private var isSoundEnabled = true
    @State private var showCard = false      // 🆕 الكارد

    var body: some View {
        ZStack {
            Color(red: 0.96, green: 0.95, blue: 0.89)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 70)
                
                Button(action: {
                }) {
                    Text("اكرمك الله")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 139/255, green: 69/255, blue: 19/255))
                        .frame(width: 250, height: 70)
                        .background(
                            RoundedRectangle(cornerRadius: 35)
                                .fill(Color(red: 210/255, green: 190/255, blue: 160/255))
                        )
                        .shadow(color: .black.opacity(0.2), radius: 8)
                }
                
                Spacer()
                
                ZStack {
                    cupView
                        .offset(y: 110)
                    
                    ZStack(alignment: .topLeading) {
                        Image("Object1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 280, height: 280)
                            .rotationEffect(.degrees(viewModel.isPouringCoffee ? -35 : 0), anchor: .topTrailing)
                    }
                    .offset(x: 75, y: -70)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: viewModel.isPouringCoffee)
                    .onTapGesture {
                        viewModel.handleDallahTap()
                    }
                }
                .frame(maxHeight: .infinity)
                
                Spacer()
                    .frame(height: 80)
            }
            
            // الأزرار
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
            
            // الإعدادات
            SettingsCardView(
                isPresented: $showSettings,
                isSoundEnabled: $isSoundEnabled,
                onReplay: {
                }
            )

            // ───── الكارد عند الضغط على الفنجال ─────
            if showCard {
                ZStack {
                    Color.black.opacity(0.1)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showCard = false
                            }
                        }

                    Card()
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var cupView: some View {
        Image("Object2")
            .resizable()
            .scaledToFit()
            .frame(width: 220, height: 220)
            .rotationEffect(.degrees(viewModel.cupRotation))
            .scaleEffect(viewModel.cupScale)
            .onTapGesture {
                viewModel.handleCupTap()
                // 🆕 الكارد يطلع عند الضغط على الفنجال
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    showCard = true
                }
            }
    }
}

#Preview {
    CoffeeGameView()
}
