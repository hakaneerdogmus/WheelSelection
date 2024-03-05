//
//  SpinDurationViewModel.swift
//  selectionWheel
//
//  Created by Hakan ERDOĞMUŞ on 3.02.2024.
//

import SwiftUI

class SpinDurationViewModel: ObservableObject {
    private let userDefault: UserDefault = UserDefault.shared
    
    @Published var spinDuraionItems: [SpinDurationModel]
   
    init() {
        self.spinDuraionItems = [
            SpinDurationModel(id: 0, duration: Double(2), isChecked: true),
            SpinDurationModel(id: 1, duration: Double(3)),
            SpinDurationModel(id: 2, duration: Double(4)),
            SpinDurationModel(id: 3, duration: Double(5)),
            SpinDurationModel(id: 4, duration: Double(6)),
            SpinDurationModel(id: 5, duration: Double(7)),
            SpinDurationModel(id: 6, duration: Double(8)),
            SpinDurationModel(id: 7, duration: Double(9)),
            SpinDurationModel(id: 8, duration: Double(10)),
        ]
    }
    //Selected spin duration
    func selectDuration(at index: Int) {
        self.spinDuraionItems.indices.forEach { self.spinDuraionItems[$0].isChecked = false }
        self.spinDuraionItems[index].isChecked.toggle()
        self.userDefault.saveSpinDuration(spinDurationModel: self.spinDuraionItems[index])
    }
    //Load selected Index
    func loadSelectedSpinDuration() {
        if let savedSpinDuration = userDefault.getSpinDuration() {
            if let index = spinDuraionItems.firstIndex(where: { $0.id == savedSpinDuration.id }) {
                spinDuraionItems.indices.forEach { spinDuraionItems[$0].isChecked = false }
                spinDuraionItems[index].isChecked = true
            } else {
                print("Get Duration Index Error")
            }
        } else {
            print("Get SavedSpinDuration Error")
        }
    }
}
