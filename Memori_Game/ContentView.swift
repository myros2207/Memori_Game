import SwiftUI

struct MemoryGameView: View {
    // Przykładowe dane do podglądu
    @State private var score = 0
    @State private var timeElapsed = 0
    @State private var resetText = ""
    // Timer tylko do prezentacji wizualnej
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Stylowe gradientowe tło
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
            
            VStack(spacing: 20) {
                // 🔢 Nagłówek
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
                    Button(action: {
                        // Tutaj logika resetu
                        resetText = ""
                    }) {
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
                
                // 🃏 Plansza 4x4
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                    ForEach(0..<16) { _ in
                        CardView()
                    }
                }
                .padding()
                
                Spacer()
            }
        }
//        .onReceive(timer) { _ in
//            timeElapsed += 1
//        }
    }
}

// MARK: - Styl pojedynczej karty
struct CardView: View {
    @State private var isFlipped = false
    
    var body: some View {
        ZStack {
            if isFlipped {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [.white, .cyan.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(radius: 5)
                    .overlay(
                        Image(systemName: "star.fill") // przykładowa ikonka
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.blue)
                            .padding(20)
                    )
                    .transition(.scale)
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
                            .padding(20)
                    )
                    .transition(.scale)
            }
        }
        .frame(height: 80)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                isFlipped.toggle()
            }
        }
    }
}

#Preview {
    MemoryGameView()
}
