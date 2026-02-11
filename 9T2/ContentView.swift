


import SwiftUI

struct DView: View {
    @State private var showCard = false
    @State private var showSettings = false
    @State private var puzzleKey = UUID()
    @State private var isSoundEnabled = true  
    var body: some View {
        ZStack {
            Color(red: 245/255, green: 235/255, blue: 220/255)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                PuzzleGameView(
                    imageName: "1",
                    onComplete: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                            showCard = true
                        }
                    },
                    isSoundEnabled: $isSoundEnabled                )
                .id(puzzleKey)
            }
            .ignoresSafeArea()
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
    
            if showCard {
                ZStack {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showCard = false
                            }
                        }
                    
                    Card3()
                        .transition(.scale.combined(with: .opacity))
                }
            }
            
            SettingsCardView(
                isPresented: $showSettings,
                isSoundEnabled: $isSoundEnabled,
                onReplay: {
                    puzzleKey = UUID()
                    showCard = false
                }
            )
        }
    }
}

#Preview {
    DView()
        .previewInterfaceOrientation(.landscapeLeft)
}
