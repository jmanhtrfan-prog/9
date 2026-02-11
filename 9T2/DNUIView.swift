//
//  DNUIView.swift
//  9T2
//
//  Created by Jumana on 22/08/1447 AH.
//

import SwiftUI

struct DNUIView: View {
    @State private var showSettings = false
    @State private var isSoundEnabled = true
    @Environment(\.presentationMode) var presentationMode
    
    // 🆕 بيانات من DJUIView
    let title: String
    let description: String
    let imageName: String
           
    var body: some View {
        ZStack {
            // الخلفية
            Color(red: 245/255, green: 235/255, blue: 220/255)
                .ignoresSafeArea()
            
            // 🆕 محتوى DJUIView (الصورة والعنوان)
            VStack(spacing: 0) {
                Spacer()
                
                Spacer()
                    .frame(height: 70)
                                
                // مربع "ابدأ العارضة" - ثابت (مو زر)
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
            
            // الأزرار فوق كل شي
            VStack {
                HStack {
                    // زر الرجوع
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
                    .padding(.trailing, 30)
                    .padding(.top, -10)
                }
                
                Spacer()
            }
            
            // 🆕 إضافة شاشة الإعدادات
            SettingsCardView(
                isPresented: $showSettings,
                isSoundEnabled: $isSoundEnabled,  // 🔊 ربط الصوت
                onReplay: {
                }
            )
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    DNUIView(
        title: "عنوان",
        description: "وصف مختصر للمحتوى يظهر هنا للتجربة.",
        imageName: "DN"
    )
}
