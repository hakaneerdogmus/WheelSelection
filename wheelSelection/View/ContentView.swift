//
//  ContentView.swift
//  selectionWheel
//
//  Created by Hakan ERDOĞMUŞ on 8.01.2024.
//

import SwiftUI
import CoreData
import AVFoundation

struct ContentView: View {
    @State private var isAddWheelSheetPresented = false
    @State private var isSortingSheetPresented = false
    @State private var wheelItems: [WheelItem] = (UserDefault.shared.getData() ?? [])
    
    @Binding var shouldPlaySound: Bool
    @Binding var isSpeakResultActive: Bool
    @Binding var isDarkModEnabled: Bool
    @Binding var isVibration: Bool
    
    private let userDefault: UserDefault = UserDefault.shared
    private let title: String = "Wheel"
    
    var body: some View {
        NavigationView {
            VStack{
                if (wheelItems.isEmpty) {
                    Button(action: {
                        isAddWheelSheetPresented.toggle()
                    }, label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 75))
                    })
                    Text("There is no Wheel")
                    Text("Press '+' for adding new Wheel.")
                } else {
                    VStack{
                        List{
                            ForEach(wheelItems, id: \.id) { item in
                                NavigationLink(destination: Spin( id: "\(item.id)", choices: item.choices, shouldPlaySound: shouldPlaySound, isSpeakResultActive: isSpeakResultActive), label: {
                                    VStack(alignment: .leading){
                                        Text(item.name)
                                            .fontWeight(.bold)
                                        HStack{
                                            let remainingWidth = UIScreen.main.bounds.width
                                            ForEach(item.choices.prefix(3), id: \.self) { choice in
                                                
                                                let textSize = choice.size(withAttributes: [.font: UIFont.systemFont(ofSize: 17.0)])
                                                
                                                if textSize.width < remainingWidth {
                                                    Text(choice)
                                                        .foregroundColor(Color.gray)
                                                        .lineLimit(1)
                                                }
                                            }
                                        }
                                    }
                                })
                            }
                            .onDelete(perform: deleteItem)
                        }
                    }
                    .onAppear {
                        wheelItems = userDefault.wheels
                    }
                }
            }
            .navigationBarTitle(self.title, displayMode: .inline)
            .sheet(isPresented: $isAddWheelSheetPresented,onDismiss: {
                wheelItems = userDefault.wheels
            } , content: {
                WheelAdd(isEditingWheel: true, spinNameText: "", spinChoiceText: [])
            })
                    
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isAddWheelSheetPresented.toggle()
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }
                //Title
                ToolbarItem(placement: .principal) {
                    Text(self.title)
                        .font(.largeTitle.bold())
                }
                //Not Button
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button {
//                        isSortingSheetPresented.toggle()
//                    } label: {
//                        Image(systemName: "list.bullet")
//                    }
//                }
                //Settings Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SettingsView(shouldPlaySound: $shouldPlaySound, isSpeakResultActive: $isSpeakResultActive, isDarkModEnabled: $isDarkModEnabled, isVibration: $isVibration)
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
        }
    }
    func deleteItem(at offset: IndexSet) {
        userDefault.deleteIndexData(offset: offset)
        wheelItems.remove(atOffsets: offset)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(shouldPlaySound: .constant(false), isSpeakResultActive: .constant(false), isDarkModEnabled: .constant(false), isVibration: .constant(false))
    }
}
