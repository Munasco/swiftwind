//
//  Item.swift
//  TailwindSwiftUIExamples
//
//  Created by Munachi Ernest-Eze on 2026-02-07.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
