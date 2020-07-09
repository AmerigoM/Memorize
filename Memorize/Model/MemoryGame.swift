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
    // set this variable is private but reading it is not
    private(set) var cards: Array<Card>
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { (index) -> Bool in
                return cards[index].isFaceUp
            }.only
        }
        
        set {
            // we reset all the cards face down (in case some are up from a previous round) except the
            // new value that indexOfTheOneAndOnlyFaceUpCard just got because that's the new card for the new round
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
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
        cards.shuffle()
    }
    
    mutating func choose(card: Card) {
        // if I choose a card AND (sequential and) the card is not already faced up AND it's not matched yet
        if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            // I have chosen a card that was faced down and not yet matched
            if let potentialIndex = indexOfTheOneAndOnlyFaceUpCard {
                // I might have a match (potentialIndex is not nil so I have just turned up a second card)
                if cards[chosenIndex].content == cards[potentialIndex].content {
                    // we have a match
                    cards[chosenIndex].isMatched = true
                    cards[potentialIndex].isMatched = true
                }
                
                // flip the card
                self.cards[chosenIndex].isFaceUp = true
            } else {
                // there are zero cards face up or more than two (indexOfTheOneAndOnlyOneFaceUpCard is nil)
                
                // the indexOfTheOneAndOnlyFaceUpCard is exactly the first card we have selected
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }

    // MARK: - Card Struct

    struct Card: Identifiable {
        var isFaceUp: Bool = false {
            didSet {
                // when this variable is set
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        
        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        
        var content: CardContent
        var id: Int
    
        // MARK: - Bonus Time

        // this could give us match bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up

        // can be zero which means "no bouns available for this card"
        var bonusTimeLimit: TimeInterval = 6

        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }

        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?

        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0

        // how much time left before the bonus opportunity runs out
        var bonusTimeRemeaning: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }

        // percentage of the bonus time remaining
        var bonusRemaning: Double {
            (bonusTimeLimit > 0 && bonusTimeRemeaning > 0) ? bonusTimeRemeaning/bonusTimeLimit : 0
        }

        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemeaning > 0
        }
        
        // wheather we are currently face up, unmatched and have not yet used the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemeaning > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}
