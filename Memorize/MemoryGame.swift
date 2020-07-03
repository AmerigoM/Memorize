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
    
    func choose(card: Card) {
        print("card chosen: \(card)")
    }

    struct Card: Identifiable {
        var isFacedUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        
        var id: Int
    }
}
