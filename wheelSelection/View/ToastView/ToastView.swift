//
//  ToastView.swift
//  selectionWheel
//
//  Created by Hakan ERDOĞMUŞ on 9.02.2024.
//

import SwiftUI

struct ToastView: View {
    var messageText: String
    var body: some View {
        ZStack{
            Color.blue
            Text(messageText)
                .foregroundColor(.white)
        }
        .cornerRadius(12)
        
        .padding()
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView(messageText: "Deneme")
    }
}
