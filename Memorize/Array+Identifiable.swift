//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by Amerigo Mancino on 06/07/2020.
//  Copyright © 2020 Amerigo Mancino. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int {
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        return 0
    }
}
