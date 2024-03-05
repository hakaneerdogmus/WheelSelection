//
//  WheelColorView.swift
//  selectionWheel
//
//  Created by Hakan ERDOĞMUŞ on 31.01.2024.
//

import SwiftUI

struct WheelColorView: View {
    
    @StateObject private var wheelColorViewModel = WheelColorViewModel()
    
    public var body: some View {
        
        List {
            ForEach(wheelColorViewModel.wheelColorItems.indices, id: \.self) { index in
                HStack {
                    Button(action: {
                        wheelColorViewModel.selectItem(at: index)
                    }, label: {
                        HStack {
                            Image(wheelColorViewModel.wheelColorItems[index].image)
                                .resizable()
                                .scaledToFit()
                                .offset(x: -UIScreen.main.bounds.width * 0.08)
                            Spacer()
                            Image(systemName: wheelColorViewModel.wheelColorItems[index].isChecked ? "checkmark" : "")
                        }
                    })
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width * 1.1)
        .onAppear {
            wheelColorViewModel.loadSelectedWheelColor()
        }
    }
}

struct WheelColorView_Previews: PreviewProvider {
    static var previews: some View {
        WheelColorView()
    }
}
