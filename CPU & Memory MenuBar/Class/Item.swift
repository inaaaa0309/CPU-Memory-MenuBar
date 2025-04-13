//
//  Item.swift
//  CPU & Memory MenuBar
//
//  Created by 稲谷究 on 2025/04/13.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timerInterval: TimeInterval
    
    init(timerIntarval: TimeInterval) {
        self.timerInterval = timerIntarval
    }
}
