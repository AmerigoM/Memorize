//
//  Array+Only.swift
//  Memorize
//
//  Created by Amerigo Mancino on 06/07/2020.
//  Copyright © 2020 Amerigo Mancino. All rights reserved.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
