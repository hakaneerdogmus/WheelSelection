//
//  WheelColorModel.swift
//  selectionWheel
//
//  Created by Hakan ERDOĞMUŞ on 31.01.2024.
//

import SwiftUI

struct WheelColorModel: Codable, Hashable {
    let id : Int
    var colors: [String]
    var isChecked: Bool = false
    var image: String
}
