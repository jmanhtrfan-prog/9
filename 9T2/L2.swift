import SwiftUI

struct MainView: View {
    @State private var showSettings = false
    @State private var isSoundEnabled = true
    @State private var showImage11 = true 
    @State private var showCard = false
    
    var body: some View {
        ZStack {
            Color(red: 245/255, green: 235/255, blue: 220/255)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                Spacer()
                    .frame(height: 80)
                Text("ابدأ العارضة")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(red: 139/255, green: 69/255, blue: 19/255))
                    .frame(width: 250, height: 70)
                    .background(
                        RoundedRectangle(cornerRadius: 35)
                            .fill(Color(red: 210/255, green: 190/255, blue: 160/255))
                    )
                    .shadow(color: .black.opacity(0.2), radius: 8)

                Spacer()
                
                VStack(spacing: -200) {
                    Image("8")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 310)
                    
                    Image("9")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 310)
                    
                    Button(action: {
                        if showImage11 {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showImage11 = false
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                                    showCard = true
                                }
                            }
                        }
                    }) {
                        Image(showImage11 ? "11" : "10")  // 🔄 تتغير بين 11 و 10
                            .resizable()
                            .scaledToFit()
                            .frame(height: 310)
                    }
                }
                .offset(y: 11)
                
                Spacer()
                    .frame(height: 100)
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
                    showImage11 = true
                    showCard = false
                }
            )
            
            if showCard {
                ZStack {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showCard = false
                            }
                        }
                    
                    Card2()
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }
}
#Preview {
    MainView()
        .previewInterfaceOrientation(.landscapeLeft)
}
