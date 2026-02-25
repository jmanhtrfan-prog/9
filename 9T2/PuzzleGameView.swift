import SwiftUI
import UIKit
import AVFoundation

struct PuzzlePiece: Identifiable {
    let id = UUID()
    let image: UIImage
    var currentPosition: CGPoint
    let correctPosition: CGPoint
    let row: Int
    let col: Int
    var isPlaced: Bool = false
    var showGreenBorder: Bool = false
    let index: Int
}

struct PieceInStripView: View {
    let piece: PuzzlePiece
    let pieceSize: CGFloat
    let isDragged: Bool
    
    var body: some View {
        Image(uiImage: piece.image)
            .resizable()
            .frame(width: pieceSize, height: pieceSize)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white, lineWidth: 3)
            )
            .shadow(color: .black.opacity(0.4), radius: 8)
            .opacity(isDragged ? 0.3 : 1.0)
    }
}

struct PuzzleGameView: View {
    @State private var pieces: [PuzzlePiece] = []
    @State private var completedPieces: Int = 0
    @State private var draggedPiece: PuzzlePiece?
    @State private var dragPosition: CGPoint = .zero
    @State private var audioPlayer: AVAudioPlayer?
    @State private var showPreview = true     // 👈 عرض الصورة الكاملة
    @State private var startGame = false      // 👈 بدء اللعب
    
    let rows = 3
    let columns = 4
    let imageName: String
    var onComplete: (() -> Void)?
    @Binding var isSoundEnabled: Bool
    
    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width * 0.88
            let availableHeight = geometry.size.height * 0.68
            
            let pieceWidth = availableWidth / CGFloat(columns)
            let pieceHeight = availableHeight / CGFloat(rows)
            let pieceSize = min(pieceWidth, pieceHeight)
            
            let actualPuzzleWidth = pieceSize * CGFloat(columns)
            let actualPuzzleHeight = pieceSize * CGFloat(rows)
            
            ZStack {
                // الشبكة الخلفية
                VStack(spacing: 0) {
                    ForEach(0..<rows, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<columns, id: \.self) { col in
                                Rectangle()
                                    .fill(Color.white.opacity(0.1))
                                    .frame(width: pieceSize, height: pieceSize)
                                    .border(Color.white.opacity(0.4), width: 1)
                            }
                        }
                    }
                }
                .frame(width: actualPuzzleWidth, height: actualPuzzleHeight)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2 - 35)
                
                // البرواز
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(red: 210/255, green: 190/255, blue: 160/255), lineWidth: 3)
                    .frame(width: actualPuzzleWidth + 6, height: actualPuzzleHeight + 6)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2 - 35)
                
                // 🖼️ الصورة الكاملة في مكان الشبكة
                if showPreview {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: actualPuzzleWidth, height: actualPuzzleHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2 - 35)
                }
                
                // شريط القطع
                if startGame {
                    VStack {
                        Spacer()
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(pieces.filter { !$0.isPlaced }) { piece in
                                    PieceInStripView(
                                        piece: piece,
                                        pieceSize: pieceSize * 0.85,
                                        isDragged: draggedPiece?.id == piece.id
                                    )
                                    .gesture(
                                        DragGesture(minimumDistance: 15, coordinateSpace: .global)
                                            .onChanged { value in
                                                draggedPiece = piece
                                                dragPosition = value.location
                                            }
                                            .onEnded { value in
                                                handleDragEnd(
                                                    piece: piece,
                                                    location: value.location,
                                                    pieceSize: pieceSize,
                                                    puzzleWidth: actualPuzzleWidth,
                                                    puzzleHeight: actualPuzzleHeight,
                                                    screenWidth: geometry.size.width,
                                                    screenHeight: geometry.size.height
                                                )
                                                draggedPiece = nil
                                            }
                                    )
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                        }
                        .frame(height: pieceSize * 0.9 + 20)
                        .background(Color(red: 210/255, green: 190/255, blue: 160/255))
                        .cornerRadius(12)
                        .padding(.bottom, 85)
                        .padding(.horizontal, 8)
                    }
                }
                
                // القطع الموضوعة
                if startGame {
                    ForEach(pieces.filter { $0.isPlaced }) { piece in
                        let isTopLeft = piece.row == 0 && piece.col == 0
                        let isTopRight = piece.row == 0 && piece.col == (columns - 1)
                        let isBottomLeft = piece.row == (rows - 1) && piece.col == 0
                        let isBottomRight = piece.row == (rows - 1) && piece.col == (columns - 1)
                        
                        Image(uiImage: piece.image)
                            .resizable()
                            .frame(width: pieceSize, height: pieceSize)
                            .clipShape(
                                UnevenRoundedRectangle(
                                    topLeadingRadius: isTopLeft ? 10 : 0,
                                    bottomLeadingRadius: isBottomLeft ? 10 : 0,
                                    bottomTrailingRadius: isBottomRight ? 10 : 0,
                                    topTrailingRadius: isTopRight ? 10 : 0
                                )
                            )
                            .overlay(
                                UnevenRoundedRectangle(
                                    topLeadingRadius: isTopLeft ? 10 : 0,
                                    bottomLeadingRadius: isBottomLeft ? 10 : 0,
                                    bottomTrailingRadius: isBottomRight ? 10 : 0,
                                    topTrailingRadius: isTopRight ? 10 : 0
                                )
                                .stroke(piece.showGreenBorder ? Color.green : Color.clear, lineWidth: 3)
                            )
                            .position(piece.currentPosition)
                            .allowsHitTesting(false)
                    }
                }
                
                // القطعة المسحوبة
                if let dragged = draggedPiece, startGame {
                    Image(uiImage: dragged.image)
                        .resizable()
                        .frame(width: pieceSize * 0.85, height: pieceSize * 0.85)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.yellow, lineWidth: 4)
                        )
                        .shadow(color: .yellow.opacity(0.6), radius: 15)
                        .scaleEffect(1.1)
                        .position(dragPosition)
                        .allowsHitTesting(false)
                        .zIndex(999)
                }
            }
        }
        .onAppear {
            startSequence()
        }
    }
    
    // 🎬 تسلسل العرض
    func startSequence() {
        createPuzzle()
        loadSound()
        
        // 1️⃣ عرض الصورة الكاملة لمدة 3 ثواني
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            // 2️⃣ إخفاء الصورة وبدء اللعبة مباشرة
            withAnimation(.easeOut(duration: 0.5)) {
                showPreview = false
                startGame = true
            }
        }
    }
    
    func loadSound() {
        if let soundURL = Bundle.main.url(forResource: "POP", withExtension: "m4a") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.prepareToPlay()
                audioPlayer?.volume = 1.0
                audioPlayer?.enableRate = true
                audioPlayer?.rate = 1.5
            } catch {
                print("❌ خطأ في تحميل الصوت: \(error)")
            }
        }
    }
    
    func playSound() {
        guard isSoundEnabled else { return }
        
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        audioPlayer?.volume = 1.0
        audioPlayer?.play()
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred(intensity: 1.0)
    }
    
    func handleDragEnd(piece: PuzzlePiece, location: CGPoint, pieceSize: CGFloat, puzzleWidth: CGFloat, puzzleHeight: CGFloat, screenWidth: CGFloat, screenHeight: CGFloat) {
        if let index = pieces.firstIndex(where: { $0.id == piece.id }) {
            let correctX = CGFloat(piece.col) * pieceSize + (screenWidth / 2 - puzzleWidth / 2) + (pieceSize / 2)
            let correctY = CGFloat(piece.row) * pieceSize + (screenHeight / 2 - puzzleHeight / 2) - 35 + (pieceSize / 2)
            
            let distance = sqrt(
                pow(location.x - correctX, 2) +
                pow(location.y - correctY, 2)
            )
            
            if distance < 60 {
                pieces[index].currentPosition = CGPoint(x: correctX, y: correctY)
                pieces[index].isPlaced = true
                pieces[index].showGreenBorder = true
                completedPieces += 1
                
                playSound()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    if index < pieces.count {
                        pieces[index].showGreenBorder = false
                    }
                }
                
                if completedPieces == rows * columns {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        let successGenerator = UINotificationFeedbackGenerator()
                        successGenerator.notificationOccurred(.success)
                        onComplete?()
                    }
                }
            }
        }
    }
    
    func createPuzzle() {
        guard let image = UIImage(named: imageName) else {
            print("❌ Image '\(imageName)' not found!")
            return
        }
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let availableWidth = screenWidth * 0.88
        let availableHeight = screenHeight * 0.68
        
        let pieceWidth = availableWidth / CGFloat(columns)
        let pieceHeight = availableHeight / CGFloat(rows)
        let pieceSize = min(pieceWidth, pieceHeight)
        
        let actualPuzzleWidth = pieceSize * CGFloat(columns)
        let actualPuzzleHeight = pieceSize * CGFloat(rows)
        
        let imagePieceWidth = image.size.width / CGFloat(columns)
        let imagePieceHeight = image.size.height / CGFloat(rows)
        
        var tempPieces: [PuzzlePiece] = []
        var pieceIndex = 0
        
        for row in 0..<rows {
            for col in 0..<columns {
                let x = CGFloat(col) * imagePieceWidth
                let y = CGFloat(row) * imagePieceHeight
                let rect = CGRect(
                    x: x,
                    y: y,
                    width: imagePieceWidth,
                    height: imagePieceHeight
                )
                
                if let cgImage = image.cgImage?.cropping(to: rect) {
                    let pieceImage = UIImage(cgImage: cgImage)
                    
                    // 👈 القطع تبدأ في الشريط مباشرة
                    let randomX = screenWidth / 2
                    let randomY = screenHeight - 80
                    
                    let correctX = CGFloat(col) * pieceSize + (screenWidth / 2 - actualPuzzleWidth / 2) + (pieceSize / 2)
                    let correctY = CGFloat(row) * pieceSize + (screenHeight / 2 - actualPuzzleHeight / 2) - 35 + (pieceSize / 2)
                    
                    let piece = PuzzlePiece(
                        image: pieceImage,
                        currentPosition: CGPoint(x: randomX, y: randomY),  // 👈 في الشريط
                        correctPosition: CGPoint(x: correctX, y: correctY),
                        row: row,
                        col: col,
                        index: pieceIndex
                    )
                    tempPieces.append(piece)
                    pieceIndex += 1
                }
            }
        }
        
        pieces = tempPieces.shuffled()
        print("✅ Created \(pieces.count) puzzle pieces (3×4)")
    }
}

#Preview {
    PuzzleGameView(
        imageName: "2",
        isSoundEnabled: .constant(true)
    )
}
