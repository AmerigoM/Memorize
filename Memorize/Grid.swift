//
//  Grid.swift
//  Memorize
//
//  Created by Amerigo Mancino on 06/07/2020.
//  Copyright © 2020 Amerigo Mancino. All rights reserved.
//

import SwiftUI

// the where keyboard creates a constraint for the input type Item
struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    // the two arguments for this view
    var items: [Item]
    var viewForItem: (Item) -> ItemView
    
    init(_ items: [Item], viewForItem: @escaping (Item)->ItemView) {
        self.items = items
        self.viewForItem = viewForItem
    }
    
    // main body
    var body: some View {
        GeometryReader { geometry in
            self.body(for: GridLayout(itemCount: self.items.count, in: geometry.size))
        }
    }
    
    // MARK: - Helper body functions
    
    func body(for layout: GridLayout) -> some View {
        ForEach(self.items) { item in
            self.body(for: item, in: layout)
        }
    }
    
    func body(for item: Item, in layout: GridLayout) -> some View {
        let index = items.firstIndex(matching: item)
        return viewForItem(item)
            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
            .position(layout.location(ofItemAt: index))
    }
}
