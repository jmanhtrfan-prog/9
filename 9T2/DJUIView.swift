import SwiftUI

struct DJUIView: View {
    @State private var showSettings = false
    @State private var isSoundEnabled = true
    @State private var showCard = false
    @Environment(\.presentationMode) var presentationMode

    let title: String
    let description: String
    let imageName: String

    var body: some View {
        ZStack {
            // الخلفية
            Color(red: 245/255, green: 235/255, blue: 220/255)
                .ignoresSafeArea()

            // صورة اللبس بالحجم الطبيعي
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 70)

                Text("الخزانة")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(red: 139/255, green: 69/255, blue: 19/255))
                    .frame(width: 180, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 35)
                            .fill(Color(red: 210/255, green: 190/255, blue: 160/255))
                    )
                    .shadow(color: .black.opacity(0.2), radius: 8)

                Spacer()

                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 500)
                    .padding(.horizontal, 40)

                Spacer()
            }

            // الأزرار العلوية
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
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
                onReplay: {}
            )

            // ───── الكارد بعد 5 ثواني ─────
            if showCard {
                ZStack {
                    Color.black.opacity(0.1)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showCard = false
                            }
                        }

                    Card10()
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    showCard = true
                }
            }
        }
    }
}

#Preview {
    DJUIView(
        title: "الخزانة",
        description: "وصف تجريبي",
        imageName: "DJ"
    )
}
