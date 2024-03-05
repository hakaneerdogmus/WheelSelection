//
//  UserDefault.swift
//  selectionWheel
//
//  Created by Hakan ERDOĞMUŞ on 10.01.2024.
//

import Foundation

class UserDefault {
    static let shared = UserDefault()
    
    private init() { }
    
    let key = "wheelKey"
    let wheelColorKey = "wheelColorKey"
    let wheelDurationKey = "wheelDurationKey"
    let defaults = UserDefaults.standard
    
    @Published var wheels: [WheelItem] = []
    @Published var wheelsColor : [String] = []
    
    //Save Spin Duration
    func saveSpinDuration(spinDurationModel: SpinDurationModel) {
        let encoder = JSONEncoder()
        if let encodeSpinDuration = try? encoder.encode(spinDurationModel) {
            UserDefaults.standard.set(encodeSpinDuration, forKey: wheelDurationKey)
        }
    }
    //Het SpinDuraiton
    func getSpinDuration() -> SpinDurationModel? {
        if let savedDuration = UserDefaults.standard.data(forKey: wheelDurationKey) {
            let decoder = JSONDecoder()
            if let decodedDuration = try? decoder.decode(SpinDurationModel.self, from: savedDuration) {
                return decodedDuration
            }
        }
        return nil
    }
    
    
    //Save WheelColor
    func saveWheelColor(wheelColor: WheelColorModel) {
        // Seçilen renkleri kaydet
        let encoder = JSONEncoder()
        if let encodedColors = try? encoder.encode(wheelColor) {
            UserDefaults.standard.set(encodedColors, forKey: wheelColorKey)
        }
    }
    //Get WheelColors
    func getWheelColors() -> WheelColorModel? {
        // UserDefaults'dan renkleri yükle
        if let savedColors = UserDefaults.standard.data(forKey: wheelColorKey) {
            let decoder = JSONDecoder()
            if let decodedColors = try? decoder.decode(WheelColorModel.self, from: savedColors) {
                wheelsColor = decodedColors.colors
                return decodedColors
            }
        }
        return nil
    }
    //Save Data
    func saveData(wheelItem: WheelItem) {
        wheels = getData() ?? []
        if let isWheelIndex = wheels.firstIndex(where: {$0.id == wheelItem.id}) {
            wheels[isWheelIndex] = wheelItem
        } else {
            wheels.insert(wheelItem, at: 0)
        }
        if let jsonData = try? JSONEncoder().encode(wheels) {
            defaults.set(jsonData, forKey: key)
        }
    }
    //UpdateData
    func updateData(uuid: String, name: String, choices: [String]) {
        if var oldWheelData = getData() {
            if let index = oldWheelData.firstIndex(where: {$0.id == UUID(uuidString: uuid) }) {
                oldWheelData[index].name = name
                oldWheelData[index].choices = choices
                saveData(wheelItem: oldWheelData[index])
                self.wheels = getData() ?? []
            } else {
                print("index Error")
            }
        } else {
            print("GetData() Error")
        }
    }
    //Get Data
    func getData() -> [WheelItem]? {
        if let getJsonData = defaults.value(forKey: key) {
            if let jsonDecode = try? JSONDecoder().decode([WheelItem].self, from: getJsonData as! Data) {
                wheels = jsonDecode
                return wheels
            } else {
                print("JsonDecode Error")
            }
        } else {
            print("Get Data Error")
        }
        return nil
    }
    // Selected Index Delete
    func deleteIndexData(offset: IndexSet) {
        if var wheelAr = getData() {
            wheelAr.remove(atOffsets: offset)
            if let jsonData = try? JSONEncoder().encode(wheelAr) {
                defaults.set(jsonData, forKey: key)
                if let newWheel = getData() {
                    self.wheels = newWheel
                    return
                }
            }
        } else {
            print("Delete Index Data Error")
        }
    }
    //All Remove
    func allRemoveData(key: String) {
        defaults.removeObject(forKey: key)
        wheels.removeAll()
    }
}
