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

struct MemoryGame<CardContent> where CardContent: Equatable {
    var cards: Array<Card>
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { (index) -> Bool in
                return cards[index].isFacedUp
            }.only
        }
        
        set {
            // we reset all the cards face down (in case some are up from a previous round) except the
            // new value that indexOfTheOneAndOnlyFaceUpCard just got because that's the new card for the new round
            for index in cards.indices {
                cards[index].isFacedUp = (index == newValue)
            }
        }
    }
    
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
        // if I choose a card AND (sequential and) the card is not already faced up AND it's not matched yet
        if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFacedUp, !cards[chosenIndex].isMatched {
            // I have chosen a card that was faced down and not yet matched
            if let potentialIndex = indexOfTheOneAndOnlyFaceUpCard {
                // I might have a match (potentialIndex is not nil so I have just turned up a second card)
                if cards[chosenIndex].content == cards[potentialIndex].content {
                    // we have a match
                    cards[chosenIndex].isMatched = true
                    cards[potentialIndex].isMatched = true
                }
                
                // flip the card
                self.cards[chosenIndex].isFacedUp = true
            } else {
                // there are zero cards face up or more than two (indexOfTheOneAndOnlyOneFaceUpCard is nil)
                
                // the indexOfTheOneAndOnlyFaceUpCard is exactly the first card we have selected
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }

    struct Card: Identifiable {
        var isFacedUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        
        var id: Int
    }
}
