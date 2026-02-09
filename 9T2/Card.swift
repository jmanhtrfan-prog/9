import SwiftUI

struct Card: View {
    private let beige = Color(hex: "F5E6D3")
    private let darkBeige = Color(hex: "D4B896")
    private let brown = Color(hex: "8B4513")
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(beige)
                .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
            
            VStack(spacing: 50) {
                Text("اكرمك الله")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(brown)
                
                Text("عند صبّ القهوة السعوديه، إذا قال الضيف «أكرمك الله» فهذا يعني الاكتفاء وطلب التوقف عن الصب. وتُعد هذه العبارة أسلوبًا مهذبًا يعبر به الضيف عن الشكر دون إحراج للمضيف.")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .padding(.horizontal, 25)
                
                Button {
                    // الأكشن هنا
                } label: {
                    Text("التالي")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(brown)
                        .frame(width: 150, height: 50)
                        .background(
                            Capsule()
                                .fill(darkBeige)
                        )
                }
                .padding(.top, 10)
            }
            .padding(.vertical, 25)
        }
        .frame(width: 320, height: 450)
    }
}

#Preview {
    Card()
}
