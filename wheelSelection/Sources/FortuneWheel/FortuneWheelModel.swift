//
//  File.swift
//  
//
//  Created by Sameer Nawaz on 24/10/22.
//

import SwiftUI

@available(macOS 10.15, *)
@available(iOS 13.0, *)
public struct FortuneWheelModel {

    var titles: [String]
    let size: CGFloat
    var onSpinEnd: ((Int) -> ())?
    var colors: [Color]
    let pointerColor: Color
    let strokeWidth: CGFloat
    let strokeColor: Color
    var animDuration: Double
    var animation: Animation
    let getWheelItemIndex: (() -> (Int))?
    
    public init(
        titles: [String], size: CGFloat, onSpinEnd: ((Int) -> ())?,
        colors: [Color]? = nil,
        pointerColor: Color? = nil,
        strokeWidth: CGFloat = 15,
        strokeColor: Color? = nil,
        animDuration: Double? = nil,
        animation: Animation? = nil,
        getWheelItemIndex: (() -> (Int))? = nil
    ) {
        self.titles = titles
        self.size = size
        self.onSpinEnd = onSpinEnd
        self.colors = colors ?? Color.spin_wheel_color
        self.pointerColor = pointerColor ?? Color(hex: "DA4533")
        self.strokeWidth = strokeWidth
        self.strokeColor = strokeColor ?? Color(hex: "252D4F")
        self.animDuration = animDuration ?? Double(2)
        self.animation = animation ?? Animation.timingCurve(0.51, 0.97, 0.56, 0.99, duration: animDuration ?? Double(2))
        self.getWheelItemIndex = getWheelItemIndex
    }
}
