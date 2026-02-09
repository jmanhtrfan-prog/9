import SwiftUI

// MARK: - Settings Card View
struct SettingsCardView: View {
    @Binding var isPresented: Bool
    @Binding var isSoundEnabled: Bool
    var onReplay: () -> Void
    
    private let beige = Color(red: 245/255, green: 235/255, blue: 220/255)
    private let darkBeige = Color(red: 210/255, green: 190/255, blue: 160/255)
    private let accentColor = Color(red: 200/255, green: 170/255, blue: 140/255)
    
    var body: some View {
        ZStack {
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            isPresented = false
                        }
                    }
                
                VStack(spacing: 0) {
                    // الهيدر
                    HStack {
                        Spacer()
                        
                        Text("الإعدادات")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                isPresented = false
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(accentColor)
                        }
                    }
                    .padding(.horizontal, 25)
                    .padding(.top, 30)
                    .padding(.bottom, 25)
                    
                    Divider()
                        .background(Color.gray.opacity(0.3))
                        .padding(.horizontal, 20)
                    
                    // المحتوى
                    VStack(spacing: 20) {
                        // Sound Toggle
                        SettingToggleRow(
                            icon: "speaker.wave.2.fill",
                            title: "الصوت",
                            isOn: $isSoundEnabled,
                            accentColor: accentColor
                        )
                        
                        // Replay Button
                        SettingActionButton(
                            icon: "arrow.clockwise",
                            title: "إعادة اللعب",
                            accentColor: accentColor,
                            action: {
                                onReplay()
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    isPresented = false
                                }
                            }
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    .padding(.bottom, 30)
                }
                .frame(width: 360, height: 350)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(beige)
                        .shadow(color: .black.opacity(0.3), radius: 25, x: 0, y: 10)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(darkBeige, lineWidth: 2)
                )
                .offset(y: isPresented ? -50 : -600)
                .animation(.spring(response: 0.5, dampingFraction: 0.75), value: isPresented)
            }
        }
    }
}

struct SettingToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    let accentColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(accentColor)
                        .shadow(color: accentColor.opacity(0.4), radius: 4)
                )
            
            Text(title)
                .font(.system(size: 19, weight: .semibold))
                .foregroundColor(.black)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: accentColor))
                .scaleEffect(0.9)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
        )
    }
}

struct SettingActionButton: View {
    let icon: String
    let title: String
    let accentColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(accentColor)
                            .shadow(color: accentColor.opacity(0.4), radius: 4)
                    )
                
                Text(title)
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                HStack(spacing: 6) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(width: 50, height: 32)
                .background(
                    Capsule()
                        .fill(accentColor)
                )
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
            )
        }
    }
}

#Preview {
    SettingsCardView(
        isPresented: .constant(true),
        isSoundEnabled: .constant(true),
        onReplay: {}
    )
    .previewInterfaceOrientation(.landscapeLeft)
}
