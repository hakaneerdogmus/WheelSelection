//
//  WheelAdd.swift
//  selectionWheel
//
//  Created by Hakan ERDOĞMUŞ on 8.01.2024.
//

import SwiftUI
import SimpleToast

struct WheelAdd: View {
    
    private let userDefault =  UserDefault.shared
    
    @State private var isShowToast: Bool = false
    @State private var nameTextFieldValues: [String] = ["",""]
   // @State private var wheelItems: [WheelItem] = []
    @State private var isTextEditing: Bool = false
    @State private var isWheelAddDismissed: Bool = false
    @State private var isEditingWheel: Bool
    @State private var nameTextFiel: String = ""
    @State private var spinNameText: String
    @State private var spinChoiceText: [String]
    @State private var uuid: String
    @State private var toastMessage: String = ""
    
    private let toastOptions = SimpleToastOptions(
        alignment: .bottom,
        hideAfter: 2,
        backdropColor: Color.black.opacity(0.2),
        animation:  .default,
        modifierType: .slide
    )
    
    private let nameErrorMessage: String = "Please complete the blank selections(Name)"             //MARK: Name Error Message
    private let choicesErrorMessage: String = "Please complete the blank selections(Choice)"        //MARK: Choices Error Message
    private let twoChoicesErrorMessage: String = "There must be at least two options"
    
    init(isEditingWheel: Bool, spinNameText: String, spinChoiceText: [String], uuid: String? = "") {
        self.isEditingWheel = isEditingWheel
        self.spinNameText = spinNameText
        self.spinChoiceText = spinChoiceText
        self.uuid = uuid ?? ""
    }
    //Body
    var body: some View {
        NavigationView{
            Form{
                //Name Section
                Section{
                    HStack(spacing: 50){
                        Text("Name")
                            .fontWeight(.bold)
                        TextField("Name", text: isEditingWheel ? $nameTextFiel : $spinNameText)
                    }
                }
                //Choise Section
                Section{
                    ForEach(0..<(isEditingWheel ? nameTextFieldValues.count : spinChoiceText.count), id: \.self) { index in
                        TextField("Choice \(index + 1)", text: isEditingWheel ? $nameTextFieldValues[index] : $spinChoiceText[index])
                    }
                        .onDelete(perform: deleteItems)
                    // Choise Add Button
                    if(spinChoiceText.count <= 19) {
                            HStack{
                                Spacer()
                                Image(systemName: "plus.circle")
                                Text("Add")
                                Spacer()
                            }
                           // .foregroundColor(Color.green)
                        .onTapGesture {
                            addItem()
                        }
                    }
                }
            }
            .simpleToast(isPresented: $isShowToast, options: toastOptions, content: {
                Text(toastMessage)
                    .bold()
                    .padding(20)
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(Color.white)
                    .cornerRadius(15)
            })
            // EditButton always active
            .environment(\.editMode, .constant(.active))
            //MARK: ToolBar Edit
            .toolbar{
                // Cancel Button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                        if(!isEditingWheel) {
                            Spin(id: uuid, choices: spinChoiceText, shouldPlaySound: false, isSpeakResultActive: false)
                        }
                    }
                label: {
                    Text("Cancel")
                }
                }
                //Note Button
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button {
//                        //Note Button
//                    }
//                label: {
//                    Image(systemName: "square.and.pencil")
//                }
//                }
                // Ok Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        okButton()
                    }
                label: {
                    Text(isEditingWheel ? "OK" : "End")
                }
                }
            }
        }
        //.accentColor(.green)
    }
    //Delete Item
    func deleteItems(at offsets: IndexSet) {
        if(isEditingWheel){
            nameTextFieldValues.remove(atOffsets: offsets)
        } else {
            spinChoiceText.remove(atOffsets: offsets)
        }
    }
    // OK Button
    func okButton() {
        if(isEditingWheel) {
            if !nameTextFieldValues.isEmpty {
                guard !nameTextFiel.isEmpty else {
                    toastMessage = nameErrorMessage
                    isShowToast.toggle()
                    return
                }
                for textValue in nameTextFieldValues {
                    if (nameTextFieldValues.count > 1) {
                        if textValue.isEmpty {
                            toastMessage = choicesErrorMessage
                            isShowToast.toggle()
                            return
                        }
                    } else {
                        toastMessage = twoChoicesErrorMessage
                        isShowToast.toggle()
                        return
                    }
                }
                //Save
                let newWheelItem = WheelItem(name: nameTextFiel, choices: nameTextFieldValues)
                userDefault.saveData(wheelItem: newWheelItem)
                //Page Closing
                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
            } else {
                toastMessage = twoChoicesErrorMessage
                isShowToast.toggle()
            }
        } else {
            if !spinChoiceText.isEmpty {
                // Edit butomu ile gelindiyse bu dsayfaya güncelleme yapılacak
                guard !spinNameText.isEmpty else {
                    toastMessage = nameErrorMessage
                    isShowToast.toggle()
                    return
                }
                for textValue in spinChoiceText {
                    print(spinChoiceText.count)
                    if (spinChoiceText.count > 1) {
                        if textValue.isEmpty {
                            toastMessage = choicesErrorMessage
                            isShowToast.toggle()
                            return
                        }
                    } else {
                        toastMessage = twoChoicesErrorMessage
                        isShowToast.toggle()
                        return
                    }
                }
                //Update Data
                userDefault.updateData(uuid: uuid, name: spinNameText, choices: spinChoiceText)
                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
            } else {
                toastMessage = twoChoicesErrorMessage
                isShowToast.toggle()
            }
    
        }
    }
    //Cancel Button
    func closeWheelAdd() {
        isWheelAddDismissed = true
    }
    //Get Wheel Item ID
    func getUUID(name: String) -> UUID? {
        if let oldWheelData = userDefault.getData() {
            if let selecItem = oldWheelData.first(where: {$0.name == name}) {
                return selecItem.id
            }
        }
        return nil
    }
    // '+' Add Wheel Button
    func addItem() {
        if(isEditingWheel) {
            guard !nameTextFiel.isEmpty else {
                toastMessage = nameErrorMessage
                isShowToast.toggle()
                return
            }
            for textValue in nameTextFieldValues {
                if textValue.isEmpty {
                    toastMessage = choicesErrorMessage
                    isShowToast.toggle()
                    return
                }
            }
            nameTextFieldValues.append("")
        } else {
            
            guard !spinNameText.isEmpty else {
                toastMessage = nameErrorMessage
                isShowToast.toggle()
                return
            }
            for textValue in spinChoiceText {
                if textValue.isEmpty {
                    toastMessage = choicesErrorMessage
                    isShowToast.toggle()
                    return
                }
            }
            spinChoiceText.append("")
        }
    }
}

struct WheelAdd_Previews: PreviewProvider {
    static var previews: some View {
        WheelAdd(isEditingWheel: true, spinNameText: "", spinChoiceText: []  )
    }
}
