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
        // Custom view for a Grid of items
        Grid(viewModel.cards) { card in
                CardView(card: card)
                    .onTapGesture {
                        self.viewModel.choose(card: card)
                }
            .padding(5)
            }
                // these modifiers are applied to all the views inside the stack
                .padding()
                .foregroundColor(Color.orange)
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
    
    // helper function containing the view body
    @ViewBuilder // this function is a list of views so it can return an empy view in the else case
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            // ZStack allows to overlap its child views on top of each other
            ZStack() {
                Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(110-90), clockwise: true)
                    .padding(5)
                    .opacity(0.4)
                Text(self.card.content)
                    // we set the content size as the minimum between the space offered
                    .font(Font.system(size: fontSize(for: size)))
            }
            .cardify(isFacedUp: card.isFaceUp)
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
