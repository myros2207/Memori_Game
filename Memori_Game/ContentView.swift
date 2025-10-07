import SwiftUI

// MARK: - Model karty
struct MemoryCard {
    let imageName: String
    var isFlipped: Bool = false
    var isMatched: Bool = false
}

// MARK: - Widok pojedynczej karty
struct CardView: View {
    var card: MemoryCard
    
    var body: some View {
        ZStack {
            if card.isFlipped || card.isMatched {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.1))
                    .shadow(radius: 5)
                    .overlay(
                        Image(card.imageName)
                            .resizable()
                            .scaledToFit()
//                            .cornerRadius(8)
                            
                    )
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(radius: 3)
                    .overlay(
                        Image(systemName: "questionmark.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white.opacity(0.5))
                            .padding(10)
                    )
            }
        }
        .frame(height: 200)
        .animation(.easeInOut(duration: 0.3), value: card.isFlipped)
    }
}

// MARK: - Memory Game View
struct MemoryGameView: View {
    // MARK: - Dane gry
    @State private var cards: [MemoryCard] = []
    @State private var score = 0
    @State private var timeElapsed = 0
    @State private var firstFlippedIndex: Int? = nil
    @State private var timerRunning = false
    
    // Timer
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Gradient background
    var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Nagłówek
                HStack {
                    VStack(alignment: .leading) {
                        Text("Punkty: \(score)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Czas: \(timeElapsed)s")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    Spacer()
                    Button(action: resetGame) {
                        Label("Reset", systemImage: "arrow.clockwise")
                            .font(.headline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                    }
                }
                .padding(.horizontal)
                
                // Plansza 4x4
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 10) {
                    ForEach(cards.indices, id: \.self) { index in
                        CardView(card: cards[index])
                            .onTapGesture {
                                cardTapped(index)
                            }
                    }
                }
                .padding()
                
                Spacer()
            }
        }
        .onAppear(perform: startGame)
        .onReceive(timer) { _ in
            if timerRunning {
                timeElapsed += 1
            }
        }
    }
    
    // MARK: - Funkcje gry
    func startGame() {
        score = 0
        timeElapsed = 0
        timerRunning = true
        firstFlippedIndex = nil
        
        // Tworzymy pary kart z obrazków z Assets.xcassets
        var tempCards: [MemoryCard] = []
        let imageNames = ["img1", "img2", "img3", "img4", "img5", "img6", "img7", "img8"] // dodaj swoje nazwy zdjęć
        for image in imageNames {
            tempCards.append(MemoryCard(imageName: image))
            tempCards.append(MemoryCard(imageName: image))
        }
        tempCards.shuffle()
        cards = tempCards
    }
    
    func resetGame() {
        startGame()
    }
    
    func cardTapped(_ index: Int) {
        guard !cards[index].isMatched && !cards[index].isFlipped else { return }
        
        if let firstIndex = firstFlippedIndex {
            // Flip second card
            cards[index].isFlipped = true
            
            // Sprawdzenie dopasowania
            if cards[firstIndex].imageName == cards[index].imageName {
                // Match!
                cards[firstIndex].isMatched = true
                cards[index].isMatched = true
                score += 1
            } else {
                // Brak dopasowania, odwrócenie po sekundzie
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    cards[firstIndex].isFlipped = false
                    cards[index].isFlipped = false
                }
            }
            
            firstFlippedIndex = nil
        } else {
            // Flip first card
            for i in cards.indices {
                if !cards[i].isMatched {
                    cards[i].isFlipped = false
                }
            }
            cards[index].isFlipped = true
            firstFlippedIndex = index
        }
        
        // Sprawdzenie zakończenia gry
        if cards.allSatisfy({ $0.isMatched }) {
            timerRunning = false
        }
    }
}

// MARK: - Preview
struct MemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryGameView()
    }
}
