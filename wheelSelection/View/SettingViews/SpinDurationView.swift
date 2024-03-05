//
//  SpinDuration.swift
//  selectionWheel
//
//  Created by Hakan ERDOĞMUŞ on 3.02.2024.
//

import SwiftUI

struct SpinDurationView: View {
    
    @StateObject private var spinDurationViewModel = SpinDurationViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        List {
            ForEach(spinDurationViewModel.spinDuraionItems.indices, id: \.self) { index in
                HStack {
                    Button(action: {
                        spinDurationViewModel.selectDuration(at: index )
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        HStack {
                            Text(Int(spinDurationViewModel.spinDuraionItems[index].duration).description)
                            Spacer()
                            Image(systemName: spinDurationViewModel.spinDuraionItems[index].isChecked ? "checkmark" : "")
                        }
                    })
                }
            }
        }
        .onAppear {
            spinDurationViewModel.loadSelectedSpinDuration()
        }
    }
}

//struct SpinDuration_Previews: PreviewProvider {
//    static var previews: some View {
//        SpinDurationView(isActive: true)
//    }
//}
