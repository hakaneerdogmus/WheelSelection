//
//  WheelItemModel.swift
//  selectionWheel
//
//  Created by Hakan ERDOĞMUŞ on 9.01.2024.
//

import SwiftUI

struct WheelItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var choices: [String]
    
    init( name: String, choices: [String]) {
        self.name = name
        self.choices = choices
    }
}
