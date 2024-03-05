//
//  Spin.swift
//  selectionWheel
//
//  Created by Hakan ERDOĞMUŞ on 9.01.2024.
//

import SwiftUI

struct Spin: View {
    
     let id: String
    @State private var selectedIndex = 0
    @State private var playersSpinEnd = ""
    @State private var selectionArray = [String]()
    @State private var isEditWheelSheetPresented = false
    
    @StateObject var fortuneWheelViewModel: FortuneWheelViewModel
    
 
    init(id: String, choices: [String], shouldPlaySound: Bool, isSpeakResultActive: Bool) {
        self.id = id
        self._fortuneWheelViewModel = StateObject(wrappedValue: FortuneWheelViewModel(model: FortuneWheelModel(titles: choices, size: 320, onSpinEnd: nil), id: id, shouldPlaySound: shouldPlaySound, isSpeakResultActive: isSpeakResultActive))
    }
    
    var body: some View {
//        var model = FortuneWheelModel(
//            titles: spinViewModel.wheelChoices, size: 320,
//            onSpinEnd: onSpinEnd
//            // getWheelItemIndex: getWheelItemIndex
//        )
        
        VStack{
            Spacer()
            HStack{
                if(fortuneWheelViewModel.model.titles.count - fortuneWheelViewModel.markedResult.count > 2)  {
                    if(fortuneWheelViewModel.playersSpinEnd != "")  {
                        Button(action: {
                            fortuneWheelViewModel.spinEndSubtractResult()
                        }, label: {
                            Image(systemName: "delete.right.fill")
                        })
                    }
                }
                Spacer()
                Text(fortuneWheelViewModel.playersSpinEnd )
                Spacer()
                //Reset Button
                if(fortuneWheelViewModel.selectionArray.count > 0) {
                    Button(action: {
                        fortuneWheelViewModel.playersSpinEnd = ""
                        fortuneWheelViewModel.selectionArray.removeAll()
                        fortuneWheelViewModel.markedResult.removeAll()
                        fortuneWheelViewModel.selectedIndex = 0
                        fortuneWheelViewModel.getWheelColorToWheelColor()
                    }, label: {
                        Image(systemName: "arrow.counterclockwise")
                    })
                }
                
            }
            .padding()
            Spacer()
            ZStack {
                    FortuneWheel(viewModel: fortuneWheelViewModel)
                    
            }
            Spacer()
            if !fortuneWheelViewModel.selectionArray.isEmpty {
                HStack {
                    Spacer()
                    Text(fortuneWheelViewModel.selectionArray.joined(separator: ", "))
                        .lineLimit(2)
                    Spacer()
                    Button(action: {
                        fortuneWheelViewModel.shareWheelResult()
                    }, label: {
                        Image(systemName: "square.and.arrow.up")
                    })
                }
                .padding()
            } else {
                HStack{
                    Text("")
                }
                .padding()
            }
            Spacer()
        }.onAppear {
            fortuneWheelViewModel.getUpdateData()
            fortuneWheelViewModel.getWheelColorToWheelColor()
        }
        .onDisappear {
            fortuneWheelViewModel.getWheelColorToWheelColor()
            AVAudioPlayerManager.shared.stopSound()
        }
        //MARK: Tool Bar
        .toolbar{
            //Wheel Name
            ToolbarItem(placement: .principal) {
                Text(self.fortuneWheelViewModel.wheelName ?? "Hata")
                    .frame(width: UIScreen.main.bounds.width * 0.5)
                    .lineLimit(1)
            }
            
            //Wheel Eding Button
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isEditWheelSheetPresented.toggle()
                }, label: {
                    Text("Edit")
                })
            }
        }
        //Wheel Add Sheet
        .sheet(isPresented: $isEditWheelSheetPresented,
               onDismiss: {
                fortuneWheelViewModel.getUpdateData()
        },
               content: {
            WheelAdd(isEditingWheel: false, spinNameText: fortuneWheelViewModel.wheelName ?? "Hata", spinChoiceText: fortuneWheelViewModel.model.titles, uuid: "\(id)" )
        })
    }
    //After the rotation is completed
    private func onSpinEnd(index: Int) {
        // your action here - based on index
        fortuneWheelViewModel.onSpinIndex(index: index)
        
    }
    //            private func getWheelItemIndex() -> Int {
    //               // return getIndexFromAPI()
    //            }
    
}

//struct Spin_Previews: PreviewProvider {
//    static var previews: some View {
//        Spin(id: nil)
//    }
//}
