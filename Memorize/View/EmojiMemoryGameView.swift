//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Amerigo Mancino on 03/07/2020.
//  Copyright © 2020 Amerigo Mancino. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    // ObservedObject will redraw the view any time viewModel
    // changes meaning any time the send function gets called
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            // Custom view for a Grid of items
            Grid(viewModel.cards) { card in
                    CardView(card: card).onTapGesture {
                        withAnimation(.linear(duration: 0.75)) {
                            self.viewModel.choose(card: card)
                        }
                    }
                .padding(5)
                }
                    // these modifiers are applied to all the views inside the stack
                    .padding()
                    .foregroundColor(Color.orange)
            // new game button
            Button(action: {
                // explicit animation
                withAnimation(.easeInOut) {
                    self.viewModel.resetGame()
                }
            }, label: {Text("New game")})
        }
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    // main view
    var body: some View {
        // GeometryReader is just a view having a geometry argument which
        // contains some parameters, among which there is the size (the
        // amount of space that is being offered to us by the container)
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    @State private var animatedBonusRemaing: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaing = card.bonusRemaning
        withAnimation(.linear(duration: card.bonusTimeRemeaning)) {
            animatedBonusRemaing = 0
        }
    }
    
    // helper function containing the view body
    @ViewBuilder // this function is a list of views so it can return an empy view in the else case
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            // ZStack allows to overlap its child views on top of each other
            ZStack() {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaing*360-90), clockwise: true)
                            .onAppear {
                                self.startBonusTimeAnimation()
                            }
                    } else {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-card.bonusRemaning*360-90), clockwise: true)
                    }
                }
                .padding(5)
                .opacity(0.4)
                .transition(.identity)

                Text(self.card.content)
                    // we set the content size as the minimum between the space offered
                    .font(Font.system(size: fontSize(for: size)))
                    // implicit animation
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
            }
            .cardify(isFacedUp: card.isFaceUp)
            // transition when animation takes place for this view
            .transition(.scale)
        }
    }
    
    // MARK: - Drawing constants
    private func fontSize(for size: CGSize) -> CGFloat {
        return min(size.width, size.height) * 0.7
    }
    
}

// MARK: - Content View Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
    }
}
