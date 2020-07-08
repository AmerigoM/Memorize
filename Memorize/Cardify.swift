//
//  Cardify.swift
//  Memorize
//
//  Created by Amerigo Mancino on 07/07/2020.
//  Copyright © 2020 Amerigo Mancino. All rights reserved.
//

import SwiftUI

// Modifier to cardify any view
struct Cardify: AnimatableModifier {
    var rotation: Double
    
    var isFacedUp: Bool {
        rotation < 90
    }
    
    var animatableData: Double {
        get { return rotation }
        set { rotation = newValue }
    }
    
    private let cornerRadius: CGFloat = 10.0
    private let edgeLineWidth: CGFloat = 3
    
    init(isFacedUp: Bool) {
        rotation = isFacedUp ? 0 : 180
    }
    
    func body(content: Content) -> some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                content
            }
                .opacity(isFacedUp ? 1 : 0)
            // Card fill background: the color is passed down from above
            RoundedRectangle(cornerRadius: cornerRadius).fill()
                .opacity(isFacedUp ? 0 : 1) // opacity allows us to control the animations easily
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0,1,0))
    }
    
}


extension View {
    func cardify(isFacedUp: Bool) -> some View {
        self.modifier(Cardify(isFacedUp: isFacedUp))
    }
}
