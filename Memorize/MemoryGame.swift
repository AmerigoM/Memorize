//
//  MemoryGame.swift
//  Memorize
//
//  Created by Amerigo Mancino on 03/07/2020.
//  Copyright © 2020 Amerigo Mancino. All rights reserved.
//
//  UI indipendent model of the game
//

import Foundation

struct MemoryGame<CardContent> {
    var cards: Array<Card>
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        // create an empty array of cards
        cards = Array<Card>()
        
        // fill the array of cards
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            
            // create the pairs
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2 + 1))
        }
    }
    
    mutating func choose(card: Card) {
        print("card chosen: \(card)")
        // flip the card
        let chosenIndex: Int = self.index(of: card)
        self.cards[chosenIndex].isFacedUp = !self.cards[chosenIndex].isFacedUp
    }
    
    func index(of card: Card) -> Int {
        for index in 0..<self.cards.count {
            if self.cards[index].id == card.id {
                return index
            }
        }
        return 0 // TODO: fix the return with a proper error value
    }

    struct Card: Identifiable {
        var isFacedUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        
        var id: Int
    }
}
