import SwiftUI

class GameNavigationManager: ObservableObject {
    @Published var currentStage: Int = 0
    @Published var hasStarted: Bool = false
    
    func nextStage() {
        currentStage += 1
    }
    
    func restart() {
        currentStage = 0
        hasStarted = false
    }
}
struct GameContainerView: View {
    @StateObject private var nav = GameNavigationManager()
    
    var body: some View {
        ZStack {
            if !nav.hasStarted {
                // الصفحة الرئيسية
                HomePageViewNavigable(nav: nav)
            } else {
                // المراحل بالترتيب
                switch nav.currentStage {
                case 0:
                                   CoffeeGameViewNavigable(nav: nav)  // القهوة → Card
                                case 1:
                                    HViewNavigable(nav: nav)           // البازل 2 → Card4
                                case 2:
                                    MainViewNavigable(nav: nav)        // العارضة → Card2
                                case 3:
                                    DViewNavigable(nav: nav)           // البازل 1 → Card3
                                case 4:
                                    DNUIViewNavigable(nav: nav)        // الخزانة 1 → Card5
                                case 5:
                                    H4ViewNavigable(nav: nav)          // البازل 4 → Card8
                                case 6:
                                    JDUIViewNavigable(nav: nav)        // الهرجة → Card6
                                case 7:
                                    H3ViewNavigable(nav: nav)          // البازل 3 → Card9
                                case 8:
                                    LViewNavigable(nav: nav)           // البيت → Card7
                                case 9:
                                    DJUIViewNavigable(nav: nav)        // الخزانة 2 → Card10
                                default:
                    // النهاية - ارجع للبداية
                    HomePageViewNavigable(nav: nav)
                        .onAppear { nav.restart() }
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: nav.currentStage)
        .animation(.easeInOut(duration: 0.3), value: nav.hasStarted)
    }
}
struct HomePageViewNavigable: View {
    @ObservedObject var nav: GameNavigationManager
    @State private var showSettings = false
    @State private var isSoundEnabled = true
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
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, geometry.safeAreaInsets.top > 0 ? 10 : 30)
                    
                    Spacer()
                    
                    if !nav.hasStarted {
                        Button(action: {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                nav.hasStarted = true
                            }
                        }) {
                            Text("ابدأ")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Color(red: 139/255, green: 69/255, blue: 19/255))
                                .frame(width: 200, height: 60)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Color(red: 210/255, green: 190/255, blue: 160/255))
                                )
                                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                        }
                        .padding(.bottom, 100)
                    }
                    
                    Spacer()
                        .frame(height: geometry.safeAreaInsets.bottom + 20)
                }
                
                SettingsCardView(
                    isPresented: $showSettings,
                    isSoundEnabled: $isSoundEnabled,
                    onReplay: { nav.restart() }
                )
            }
        }
        .ignoresSafeArea()
    }
}
struct DViewNavigable: View {
    @ObservedObject var nav: GameNavigationManager
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
                    isSoundEnabled: $isSoundEnabled
                )
                .id(puzzleKey)
            }
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: { nav.restart() }) {
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
                            withAnimation { showCard = false }
                        }
                    
                    Card3()
                        .environmentObject(nav)
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
struct HViewNavigable: View {
    @ObservedObject var nav: GameNavigationManager
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
                    imageName: "2",
                    onComplete: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                            showCard = true
                        }
                    },
                    isSoundEnabled: $isSoundEnabled
                )
                .id(puzzleKey)
            }
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: { nav.restart() }) {
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
                            withAnimation { showCard = false }
                        }
                    
                    Card4()
                        .environmentObject(nav)
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
struct MainViewNavigable: View {
    @ObservedObject var nav: GameNavigationManager
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
                        Image(showImage11 ? "11" : "10")
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
                    Button(action: { nav.restart() }) {
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
                            withAnimation { showCard = false }
                        }
                    
                    Card2()
                        .environmentObject(nav)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }
}
struct LViewNavigable: View {
    @ObservedObject var nav: GameNavigationManager
    @State private var showSettings = false
    @State private var isSoundEnabled = true
    @State private var isHouseOpen = false
    @State private var showKey = true
    @State private var showCard = false
    
    var body: some View {
        ZStack {
            Color(red: 245/255, green: 235/255, blue: 220/255)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                    .frame(height: 80)
                
                Button(action: { nav.restart() }) {
                    Text("افتح الباب")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 139/255, green: 69/255, blue: 19/255))
                        .frame(width: 250, height: 70)
                        .background(
                            RoundedRectangle(cornerRadius: 35)
                                .fill(Color(red: 210/255, green: 190/255, blue: 160/255))
                        )
                        .shadow(color: .black.opacity(0.2), radius: 8)
                }
                
                ZStack {
                    Image(isHouseOpen ? "6" : "5")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 410, height: 450)
                    
                    if showKey {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                        isHouseOpen = true
                                        showKey = false
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                                            showCard = true
                                        }
                                    }
                                }) {
                                    Image("7")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .shadow(color: .black.opacity(0.3), radius: 5)
                                }
                            }
                            .padding(.trailing, 30)
                            .padding(.bottom, 30)
                        }
                        .frame(width: 400, height: 250)
                    }
                }
                Spacer()
            }
            
            VStack {
                HStack {
                    Button(action: { nav.restart() }) {
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
                    withAnimation {
                        isHouseOpen = false
                        showKey = true
                        showCard = false
                    }
                }
            )
            
            if showCard {
                ZStack {
                    Color.black.opacity(0.1)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation { showCard = false }
                        }
                    
                    Card7()
                        .environmentObject(nav)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }
}
struct H3ViewNavigable: View {
    @ObservedObject var nav: GameNavigationManager
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
                    imageName: "3",
                    onComplete: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                            showCard = true
                        }
                    },
                    isSoundEnabled: $isSoundEnabled
                )
                .id(puzzleKey)
            }
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: { nav.restart() }) {
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
                            withAnimation { showCard = false }
                        }
                    
                    Card9()
                        .environmentObject(nav)
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
struct DNUIViewNavigable: View {
    @ObservedObject var nav: GameNavigationManager
    @State private var showSettings = false
    @State private var isSoundEnabled = true
    @State private var showCard = false

    var body: some View {
        ZStack {
            Color(red: 245/255, green: 235/255, blue: 220/255)
                .ignoresSafeArea()

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

                Image("DN")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 500)
                    .padding(.horizontal, 40)

                Spacer()
            }

            VStack {
                HStack {
                    Button(action: { nav.restart() }) {
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
                onReplay: {}
            )

            if showCard {
                ZStack {
                    Color.black.opacity(0.1)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation { showCard = false }
                        }

                    Card5()
                        .environmentObject(nav)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    showCard = true
                }
            }
        }
    }
}
struct JDUIViewNavigable: View {
    @ObservedObject var nav: GameNavigationManager
    @State private var currentLevelIndex = 0
    @State private var showAlert = false
    @State private var isCorrect = false
    @State private var score = 0
    @State private var levels: [GameLevel]
    @State private var currentDisplayedNames: [String] = []
    @State private var isReverting: Bool = false
    @State private var showCard = false
    @State private var showSettings = false
    @State private var isSoundEnabled = true

    init(nav: GameNavigationManager) {
        self._nav = ObservedObject(wrappedValue: nav)
        
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
                    Button(action: { nav.restart() }) {
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
                onReplay: { restartGame() }
            )
            
            if showCard {
                ZStack {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation { showCard = false }
                        }
                    
                    Card6()
                        .environmentObject(nav)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }

    func handleSlotTap(slotIndex: Int) {
        let level = levels[currentLevelIndex]

        if slotIndex == level.correctSlotIndex {
            currentDisplayedNames = level.revealImageNames
            isCorrect = true
            score += 10
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

    func restartGame() {
        currentLevelIndex = 0
        score = 0
        isCorrect = false
        showCard = false
        levels = levels.shuffled()
        currentDisplayedNames = levels.first?.baseImageNames ?? []
    }
}
struct H4ViewNavigable: View {
    @ObservedObject var nav: GameNavigationManager
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
                    imageName: "4",
                    onComplete: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                            showCard = true
                        }
                    },
                    isSoundEnabled: $isSoundEnabled
                )
                .id(puzzleKey)
            }
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: { nav.restart() }) {
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
                            withAnimation { showCard = false }
                        }
                    
                    Card8()
                        .environmentObject(nav)
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
struct DJUIViewNavigable: View {
    @ObservedObject var nav: GameNavigationManager
    @State private var showSettings = false
    @State private var isSoundEnabled = true
    @State private var showCard = false

    var body: some View {
        ZStack {
            Color(red: 245/255, green: 235/255, blue: 220/255)
                .ignoresSafeArea()

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

                Image("DJ")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 500)
                    .padding(.horizontal, 40)

                Spacer()
            }

            VStack {
                HStack {
                    Button(action: { nav.restart() }) {
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
                onReplay: {}
            )

            if showCard {
                ZStack {
                    Color.black.opacity(0.1)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation { showCard = false }
                        }

                    Card10()
                        .environmentObject(nav)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    showCard = true
                }
            }
        }
    }
}
struct CoffeeGameViewNavigable: View {
    @ObservedObject var nav: GameNavigationManager
    @StateObject private var viewModel = CoffeeGameViewModel()
    @State private var showSettings = false
    @State private var isSoundEnabled = true
    @State private var showCard = false

    var body: some View {
        ZStack {
            Color(red: 0.96, green: 0.95, blue: 0.89)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 70)
                
                Button(action: { nav.restart() }) {
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
            
            VStack {
                HStack {
                    Button(action: { nav.restart() }) {
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
                onReplay: {}
            )

            if showCard {
                ZStack {
                    Color.black.opacity(0.1)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation { showCard = false }
                        }

                    Card()
                        .environmentObject(nav)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }
    
    private var cupView: some View {
        Image("Object2")
            .resizable()
            .scaledToFit()
            .frame(width: 220, height: 220)
            .rotationEffect(.degrees(viewModel.cupRotation))
            .scaleEffect(viewModel.cupScale)
            .onTapGesture {
                viewModel.handleCupTap()
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    showCard = true
                }
            }
    }
}
