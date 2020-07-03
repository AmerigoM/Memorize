//
//  ContentView.swift
//  Memorize
//
//  Created by Amerigo Mancino on 03/07/2020.
//  Copyright © 2020 Amerigo Mancino. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // HStack allows to arrange its child views in a horizontal line
        HStack(spacing: 5) {
            ForEach(0..<4) { index in
                CardView(isFaceUp: true)
            }
        }
            // these modifiers are applied to all the views inside the stack
            .padding()
            .foregroundColor(Color.orange)
            .font(Font.largeTitle)
    }
}

struct CardView: View {
    var isFaceUp: Bool
    
    var body: some View {
        // ZStack allows to overlap its child views on top of each other
        ZStack() {
            if isFaceUp {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
                Text("👻")
            } else {
                // Card background: the color is passed down from above
                RoundedRectangle(cornerRadius: 10.0).fill()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
