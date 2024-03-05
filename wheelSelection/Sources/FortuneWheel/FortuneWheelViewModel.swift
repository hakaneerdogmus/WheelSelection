//
//  FortuneWheelViewModel.swift
//  FortuneWheel
//
//  Created by Sameer Nawaz on 19/04/21.
//

import SwiftUI
import AVFoundation
import UIKit


@available(macOS 10.15, *)
@available(iOS 13.0, *)
class FortuneWheelViewModel: ObservableObject {
    private let userDefault = UserDefault.shared
    private let id: String
    
    private let speechManager = SpeechManager(isSpeakResultActive: false, text: "")
    
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    @Published var degree = 0.0
    @Published var model: FortuneWheelModel
    @Published var wheelName: String?
    @Published var selectedIndex = 0
    @Published var selectionArray = [String]()
    @Published var playersSpinEnd = ""
    @Published var onSpinEndIndex: Int?
    @Published var markedResult: [Int] = []
    @Published var wheelColor: [Color] = []
    @Published var shouldPlaySound: Bool?
    @Published var isSpeakResultActive: Bool?
    
    init(model: FortuneWheelModel, id: String, shouldPlaySound: Bool, isSpeakResultActive: Bool) {
        self.model = model
        self.id = id
        getUpdateData()
        self.model.onSpinEnd = onSpinIndex
        self.model.animDuration = animDuration() ?? Double(2)
        self.model.animation = Animation.timingCurve(0.51, 0.97, 0.56, 0.99, duration: animDuration() ?? Double(2))
        self.shouldPlaySound = shouldPlaySound
        self.isSpeakResultActive = isSpeakResultActive
    }
    //GetWheelStopDegree
    private func getWheelStopDegree() -> Double {
        var index = -1;
        if let method = model.getWheelItemIndex { index = method() }
        if index < 0 || index >= model.titles.count { index = Int.random(in: 0..<model.titles.count) }
        index = model.titles.count - index - 1;
        /*
         itemRange - Each items degree range (For 4, each will have 360 / 4 = 90 degrees)
         indexDegree - No. of 90 degrees to reach i item
         freeRange - Flexible degree in the item, so the pointer doesn't always point start of the item
         freeSpins - No. of spins before it goes to selected item index
         finalDegree - Final exact degree to spin and stop in the index
         */
        
        let itemRange = 360 / model.titles.count;
        let indexDegree = itemRange * index;
        let freeRange = Int.random(in: 0...itemRange);
        let freeSpins = (2...20).map({ return $0 * 360 }).randomElement()!
        var finalDegree = freeSpins + indexDegree + freeRange;
        var finalIndex = Int((360 - (finalDegree % 360)) / itemRange)
        
        while markedResult.contains(finalIndex) {
            let newFreeRange = Int.random(in: 0..<itemRange)
            let newFreeSpins = Int.random(in: 2...20) * (360 / model.titles.count)
            finalDegree = newFreeSpins + indexDegree + newFreeRange
            finalIndex = Int((360 - (finalDegree % 360)) / itemRange)
        }
        return Double(finalDegree);
    }
    //Spin Wheel
    func spinWheel() {
            //Titreşim fonksiyonu çalışması test edilecek
     //  vibrate()
        
        withAnimation(model.animation) {
            self.degree = Double(360 * Int(self.degree / 360)) + getWheelStopDegree();
        }
        // Cancel the currently pending item
        pendingRequestWorkItem?.cancel()
        // Wrap our request in a work item
        let requestWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            let count = self.model.titles.count
            let distance = self.degree.truncatingRemainder(dividingBy: 360)
            let pointer = floor(distance / (360 / Double(count )))
            if let onSpinEnd = self.model.onSpinEnd { onSpinEnd((count ) - Int(pointer) - 1) }
        }
        // Save the new work item and execute it after duration
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + model.animDuration + 1, execute: requestWorkItem)
        //Ses butonu aktif mi kontrol
        if let shouldPlaySound = shouldPlaySound {
            if shouldPlaySound {
                AVAudioPlayerManager.shared.playSound(named: "spin")
            } else {
                print("AVAudioPlayer false")
            }
        } else {
            print("shouldPlaySound ifadesi hatalı")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + model.animDuration - 0.3) {
            if let shouldPlaySound = self.shouldPlaySound {
                if shouldPlaySound {
                    AVAudioPlayerManager.shared.stopSound()
                }
            }
        }
    }

    //Subtract the result
    func spinEndSubtractResult() {
        playersSpinEnd = ""
        if let onSpinEndIndex = onSpinEndIndex {
            //Seçili index i gri renk yaptık
            if !markedResult.contains(onSpinEndIndex) {
                self.model.colors[onSpinEndIndex] = .gray
                self.markedResult.append(onSpinEndIndex)
            }
        }
    }
    //Animation Duraiton
    func animDuration() -> Double? {
        if let spinTime = userDefault.getSpinDuration() {
            // model.animDuration = spinTime.duration
            return spinTime.duration
        }
        return nil
    }
    //After the rotation is completed
    func onSpinIndex(index: Int) {
        onSpinEndIndex = index
        playersSpinEnd = self.model.titles[index]
        selectedIndex += 1
        let selectedArr = "\(selectedIndex). " + playersSpinEnd
        selectionArray.insert(selectedArr, at: 0)
        
        if let isSpeakResultActive = isSpeakResultActive {
            if isSpeakResultActive {
                speechManager.speak(text: playersSpinEnd)
                print("Sonucu seslendirme")
            }
        }
    }
    //Get update Data
    func getUpdateData() {
        if let oldData = userDefault.getData() {
            if let index = oldData.firstIndex(where: { $0.id == UUID(uuidString: id ) }) {
                self.wheelName = oldData[index].name
                self.model.titles = oldData[index].choices
            }
        }
    }
    //Share Button spin end result
    func shareWheelResult() {
        let allChoices = selectionArray.joined(separator: "\n")
        guard let appURL = URL(string: "your-app-url"), !allChoices.isEmpty else {
            return
        }
        let activityViewController = UIActivityViewController(
            activityItems: [allChoices, appURL],
            applicationActivities: nil
        )
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
    //GetWheelColor to WheelColor
    func getWheelColorToWheelColor() {
        if let savedColorsWheel = userDefault.getWheelColors() {
            model.colors.removeAll()
            for hexColor in savedColorsWheel.colors {
                let color = Color(hex: hexColor)
                model.colors.append(color)
            }
        }
        
    }
}
