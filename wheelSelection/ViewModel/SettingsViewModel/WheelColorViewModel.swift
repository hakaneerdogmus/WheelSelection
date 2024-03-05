//
//  WheelColorViewModel.swift
//  selectionWheel
//
//  Created by Hakan ERDOĞMUŞ on 1.02.2024.
//

import Foundation

class WheelColorViewModel: ObservableObject {
   
    private let userDefault: UserDefault = UserDefault.shared
    
    @Published var selectedColorIndex: Int?
    @Published var wheelColorItems: [WheelColorModel]
    
    init() {
        self.wheelColorItems = [
            WheelColorModel(id: 0, colors: ["FBE488","75AB53","D1DC59","EC9D42","DE6037","DA4533","992C4D","433589","4660A8","4291C8","FBE488","75AB53","D1DC59","EC9D42","DE6037","DA4533","992C4D","433589","4660A8","4291C8"], isChecked: true, image: "wheel1"),
            //Kırmızı renk tonları
            WheelColorModel(id: 1, colors: ["FF0000","FF4500","FF6347","FF7F50","DC143C","FF69B4","CD5C5C","B22222","FFA07A","FF1490","FF0000","FF4500","FF6347","FF7F50","DC143C","FF69B4","CD5C5C","B22222","FFA07A","FF1490"], image: "wheel2"),
            //Sarı renk tonları
            WheelColorModel(id: 2,colors: ["FAB305","FCF20F","FAD004","FA9605","C5FC28","FAD982","FFFA54","F9E782","FACB82","D6FF80","FAB305","FCF20F","FAD004","FA9605","C5FC28","FAD982","FFFA54","F9E782","FACB82","D6FF80"], image: "wheel3"),
            //Yeşil renk
            WheelColorModel(id: 3,colors: ["008000","00FF00","32CD32","008080","2E8B57","228B22","00FA9A","7CFC00","ADFF2F","6B8E23","008000","00FF00","32CD32","008080","2E8B57","228B22","00FA9A","7CFC00","ADFF2F","6B8E23"], image: "wheel4"),
            //Mavi renk tonları
            WheelColorModel(id: 4,colors: ["0000FF","1E90FF","00BFFF","87CEEB","4682B4","5F9EA0","6495ED","87CEFA","4169E1","6A5ACD","0000FF","1E90FF","00BFFF","87CEEB","4682B4","5F9EA0","6495ED","87CEFA","4169E1","6A5ACD"], image: "wheel5"),
            //Pembe
            WheelColorModel(id: 5,colors: ["9300FA","FF008D","E600FA","4200FA","FF0905","AF57FA","FF59C4","E256F9","7A57FA","FF5961","9300FA","FF008D","E600FA","4200FA","FF0905","AF57FA","FF59C4","E256F9","7A57FA","FF5961"], image: "wheel6"),
            //Turkuaz
            WheelColorModel(id: 6,colors: ["25FA8E","26DCFF","26FAD7","28FA48","2698FF","73FAAD","75F1FF","72FADB","75FA81","75C6FF","25FA8E","26DCFF","26FAD7","28FA48","2698FF","73FAAD","75F1FF","72FADB","75FA81","75C6FF"], image: "wheel7"),
        ]
    }
    //Sayfa tekrar açıldığında tik aşreti
    func loadSelectedWheelColor() {
        if let savedColorModel = userDefault.getWheelColors() {
            if let index = wheelColorItems.firstIndex(where: { $0.id == savedColorModel.id}) {
                wheelColorItems.indices.forEach { wheelColorItems[$0].isChecked = false }
                wheelColorItems[index].isChecked = true
                self.selectedColorIndex = index
            } else {
                print("Get Index Error")
            }
        } else {
            print("GetWheelColor Error")
        }
    }
    //Seçilen index
    func selectItem(at index: Int) {
        self.wheelColorItems.indices.forEach { self.wheelColorItems[$0].isChecked = false }
        self.wheelColorItems[index].isChecked.toggle()
        self.userDefault.saveWheelColor(wheelColor: self.wheelColorItems[index])
        self.selectedColorIndex = index
    }
}
