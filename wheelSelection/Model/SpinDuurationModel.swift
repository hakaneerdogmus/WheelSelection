//
//  SpinDuurationModel.swift
//  selectionWheel
//
//  Created by Hakan ERDOĞMUŞ on 3.02.2024.
//

import Foundation

struct SpinDurationModel: Codable {
    let id : Int
    var duration: Double
    var isChecked: Bool = false
}
