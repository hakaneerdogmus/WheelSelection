//
//  FortuneWheel.swift
//  FortuneWheel
//
//  Created by Sameer Nawaz on 07/04/21.
//

import SwiftUI

@available(macOS 11.0, *)
@available(iOS 14.0, *)

public struct FortuneWheel: View {

    @StateObject var viewModel: FortuneWheelViewModel
    
    public var body: some View {
        ZStack(alignment: .top) {
            ZStack(alignment: .center) {
                SpinWheelView(data: (0..<viewModel.model.titles.count).map { _ in Double(100 / viewModel.model.titles.count) },
                              labels: viewModel.model.titles, colors: viewModel.model.colors)
                .frame(width: viewModel.model.size, height: viewModel.model.size)
                    .overlay(
                        RoundedRectangle(cornerRadius: viewModel.model.size / 2)
                            .stroke(lineWidth: viewModel.model.strokeWidth)
                            .foregroundColor(viewModel.model.strokeColor)
                    )
                    .rotationEffect(.degrees(viewModel.degree))
                    .gesture(
                        DragGesture().onChanged({ (value) in
                            if value.translation.width < 0 {
                                viewModel.degree = Double(-value.translation.width)
                            }
                            
                        }).onEnded({ (value) in
                            viewModel.spinWheel()
                        })
                    )
                SpinWheelBolt()
            }
            SpinWheelPointer(pointerColor: viewModel.model.pointerColor).offset(x: 0, y: -25)
        }
    }
    

}

@available(macOS 10.15, *)
@available(iOS 13.0, *)
extension Color {
    static var spin_wheel_color: [Color] = [
        Color(hex: "FBE488"), Color(hex: "75AB53"),
        Color(hex: "D1DC59"), Color(hex: "EC9D42"),
        Color(hex: "DE6037"), Color(hex: "DA4533"),
        Color(hex: "992C4D"), Color(hex: "433589"),
        Color(hex: "4660A8"), Color(hex: "4291C8"),
        Color(hex: "FBE488"), Color(hex: "75AB53"),
        Color(hex: "D1DC59"), Color(hex: "EC9D42"),
        Color(hex: "DE6037"), Color(hex: "DA4533"),
        Color(hex: "992C4D"), Color(hex: "433589"),
        Color(hex: "4660A8"), Color(hex: "4291C8")
    ]
    
    init(hex: String, alpha: Double = 1) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) { cString.remove(at: cString.startIndex) }
        
        let scanner = Scanner(string: cString)
        scanner.currentIndex = scanner.string.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        self.init(.sRGB, red: Double(r) / 0xff, green: Double(g) / 0xff, blue:  Double(b) / 0xff, opacity: alpha)
    }
}
