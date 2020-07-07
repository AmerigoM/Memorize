//
//  Cardify.swift
//  Memorize
//
//  Created by Amerigo Mancino on 07/07/2020.
//  Copyright © 2020 Amerigo Mancino. All rights reserved.
//

import SwiftUI

// Modifier to cardify any view
struct Cardify: ViewModifier {
    
    var isFacedUp: Bool
    
    private let cornerRadius: CGFloat = 10.0
    private let edgeLineWidth: CGFloat = 3
    
    func body(content: Content) -> some View {
        ZStack {
            if isFacedUp {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                content
             } else {
                // Card fill background: the color is passed down from above
                RoundedRectangle(cornerRadius: cornerRadius).fill()
             }
        }
    }
    
}


extension View {
    func cardify(isFacedUp: Bool) -> some View {
        self.modifier(Cardify(isFacedUp: isFacedUp))
    }
}
