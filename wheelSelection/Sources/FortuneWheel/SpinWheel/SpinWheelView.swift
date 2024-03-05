//
//  SpinWheelView.swift
//  FortuneWheel
//
//  Created by Sameer Nawaz on 19/04/21.
//

import SwiftUI

@available(macOS 10.15, *)
@available(iOS 13.0, *)
struct Triangle: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addCurve(to: CGPoint(x: rect.midX, y: rect.minY), control1: CGPoint(x: rect.maxX, y: rect.minY), control2: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}

@available(macOS 10.15, *)
@available(iOS 13.0, *)
struct SpinWheelPointer: View {
    var pointerColor: Color
    var body: some View {
        Triangle().frame(width: 50, height: 50)
            .foregroundColor(pointerColor).cornerRadius(24)
            .rotationEffect(.init(degrees: 180))
            .shadow(color: Color(hex: "212121", alpha: 0.5), radius: 5, x: 0.0, y: 1.0)
    }
}

@available(macOS 10.15, *)
@available(iOS 13.0, *)
struct SpinWheelBolt: View {
    var body: some View {
        ZStack {
            Circle().frame(width: 28, height: 28)
                .foregroundColor(Color(hex: "F4C25B"))
            Circle().frame(width: 18, height: 18)
                .foregroundColor(Color(hex: "FFD25A"))
                .shadow(color: Color(hex: "404040", alpha: 0.35), radius: 3, x: 0.0, y: 1.0)
        }
    }
}

@available(macOS 10.15, *)
@available(iOS 13.0, *)
struct SpinWheelView: View {
    
    
    
    var data: [Double], labels: [String]
    
    private var colors: [Color]
    private let sliceOffset: Double = -.pi / 2
    private var fontScaleSize: CGFloat = 0.0
    @available(macOS 10.15, *)
    
    init(data: [Double], labels: [String], colors: [Color]) {
        self.data = data
        self.labels = labels
        self.colors = colors
        self.fontScaleSize = fontSizeForText(count: labels.count)
    }
    @available(macOS 10.15.0, *)
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                ForEach(0..<data.count, id: \.self) { index in
                    let offset = viewOffset(for: index, in: geo.size)
                    SpinWheelCell(startAngle: startAngle(for: index), endAngle: endAngle(for: index))
                        .fill(colors[index % colors.count])
                    Text(labels[index])
                        .frame(width: 130)
                        .lineLimit(1)
                        .foregroundColor(Color.white)
                        .font(.system(size: fontScaleSize))
                        .offset(offset)
                        .rotationEffect(.degrees(rotationAngle(for: index)), anchor: .center)
                        .zIndex(1)
                        .fixedSize()
                }
            }
        }
    }
    //ÇArkın her hücresi yazının konumlanacağı derece
    private func rotationAngle(for index: Int) -> Double {
        // Her bir Text elemanının döndürme açısını hesapla
        // Çarkın genel dönme açısı ile, her bir hücrenin dönme açısı toplamı
        let totalRotationAngle = 360.0
        let anglePerItem = totalRotationAngle / Double(data.count)
        let startingAngle =  -90.0 + (anglePerItem / 2.0 )    // Çarkın başlangıç açısı
        // Her bir hücrenin dönme açısını hesapla ve çarkın başlangıç açısını ekleyerek toplam açıyı bul
        let cellRotationAngle = (anglePerItem ) * Double(index)
        let totalAngle = startingAngle + cellRotationAngle
        return totalAngle
    }
    //Eklenen seçeneğe göre font size
    private func fontSizeForText(count: Int) -> CGFloat {
        let minFontSize: CGFloat = 8.0
        let maxFontSize: CGFloat = 20.0
        let scaleFactor = CGFloat(count) / CGFloat(20)
        let fontSize = (maxFontSize - ((maxFontSize - minFontSize) * scaleFactor))
        return fontSize
    }
    
    private func startAngle(for index: Int) -> Double {
        switch index {
        case 0: return sliceOffset
        default:
            let ratio: Double = data[..<index].reduce(0.0, +) / data.reduce(0.0, +)
            return sliceOffset + 2 * .pi * ratio
        }
    }
    
    private func endAngle(for index: Int) -> Double {
        switch index {
        case data.count - 1: return sliceOffset + 2 * .pi
        default:
            let ratio: Double = data[..<(index + 1)].reduce(0.0, +) / data.reduce(0.0, +)
            return sliceOffset + 2 * .pi * ratio
        }
    }
    
    private func viewOffset(for index: Int, in size: CGSize) -> CGSize {
        let radius = min(size.width, size.height) / 3
        let dataRatio = (2 * data[..<index].reduce(0, +) + data[index]) / (2 * data.reduce(0, +))
        let angle = CGFloat(sliceOffset + 2 * .pi * dataRatio)
        let x = CGFloat(radius)
        let y = CGFloat(0)
        return CGSize(width: x - 20, height: y)
    }
}
