//
//  CoffeeGameView.swift
//  9T2
//
//  Created by Rahaf on 10/02/2026.
//
import SwiftUI

struct CoffeeGameView: View {
    @StateObject private var viewModel = CoffeeGameViewModel()
    
    var body: some View {
        ZStack {
            Color(red: 0.96, green: 0.95, blue: 0.89)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
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
                
                // Arabic Text
                arabicText
                    .padding(.bottom, 80)
            }
            
            // Success Popup
            if viewModel.showSuccessPopup {
                successPopupOverlay
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
            }
    }
    
    private var arabicText: some View {
        Text("أكرمك الله")
            .font(.system(size: 52, weight: .bold, design: .serif))
            .foregroundColor(Color(red: 0.6, green: 0.35, blue: 0.25))
    }
    
    private var successPopupOverlay: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
            VStack(spacing: 20) {
                Text("أكرمك الله")
                    .font(.system(size: 36, weight: .bold, design: .serif))
                    .padding(.top, 30)
                Text("عند صب القهوة السعودية، إذا قال الضيف «أكرمك الله» فهذا يعني الاكتفاء وطلب التوقف عن الصب.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                Button("التالي") {
                    withAnimation { viewModel.showSuccessPopup = false }
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Capsule().fill(Color(red: 0.95, green: 0.85, blue: 0.55)))
                .padding(30)
            }
            .background(RoundedRectangle(cornerRadius: 30).fill(Color(red: 0.96, green: 0.92, blue: 0.80)))
            .padding(30)
        }
    }
}// MARK: - Preview
struct CoffeeGameView_Previews: PreviewProvider {
    static var previews: some View {
        CoffeeGameView()
    }
}

