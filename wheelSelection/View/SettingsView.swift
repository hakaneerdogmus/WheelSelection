//
//  SettingsView.swift
//  selectionWheel
//
//  Created by Hakan ERDOĞMUŞ on 8.01.2024.
//

import SwiftUI

struct SettingsView: View {
    private let userDefault =  UserDefault.shared
    private let offsetNavigationLinkX: CGFloat = -3
    private let offsetButtonX: CGFloat = 5
    
    @State private var isMailComposePresented = false
    @State private var spinDuration: String = "2"
    
    @Binding var shouldPlaySound: Bool
    @Binding var isSpeakResultActive: Bool
    @Binding var isDarkModEnabled: Bool
    @Binding var isVibration: Bool
    
    var body: some View {
        
        Form {
            Section {
                //Share App
                Button(action: {
                    shareApp()
                }, label: {
                    HStack{
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.blue)
                        Text("Shere this App")
                            .padding(.leading,10)
                            .foregroundColor(isDarkModEnabled ? Color.white : Color.black)
                    }
                })
                //Send FeedBack
                NavigationLink(destination: SendFeedbackView()) {
                    HStack {
                        Image(systemName: "text.bubble")
                            .foregroundColor(.blue)
                        Text("Send Feedback")
                            .padding(.leading,7)
                    }
                }
                //Privacy Policy
                NavigationLink(destination: WebView(urlString: "https://wheeldesicionspinwheel.godaddysites.com/privacy-policy")) {
                    HStack {
                        Image(systemName: "hand.raised")
                            .foregroundColor(.blue)
                        Text("Privacy Policy")
                            .padding(.leading,10)
                    }
                }
            }
            
            Section {
                //DarkMod
                Toggle(isOn: $isDarkModEnabled) {
                    HStack{
                        Image(systemName: "moon.stars")
                            .foregroundColor(.blue)
                        Text("Dark Theme")
                            .padding(.leading,15)
                    }
                }
                //Volume
                Toggle(isOn: $shouldPlaySound) {
                    HStack{
                        Image(systemName: "speaker.wave.2")
                            .foregroundColor(.blue)
                        Text("Volume")
                            .padding(.leading,10)
                        
                    }
                }
                //Result Speak
                Toggle(isOn: $isSpeakResultActive) {
                    HStack{
                        Image(systemName: "exclamationmark.bubble")
                            .foregroundColor(.blue)
                        Text("Speak Result")
                            .padding(.leading, 10)
                    }
                }
                //Vibration
                Toggle(isOn: $isVibration) {
                    HStack{
                        Image(systemName: "hand.tap")
                            .foregroundColor(.blue)
                        Text("Vibration")
                            .padding(.leading, 10)
                    }
                }
                
                //Color choice
                NavigationLink(destination: WheelColorView()) {
                    // Label("Color Choise", systemImage: "paintpalette")
                    // .offset(x: offsetNavigationLinkX)
                    // .padding(.leading, UIScreen.main.bounds.width * 0.01)
                    HStack {
                        Image(systemName: "paintpalette")
                            .foregroundColor(.blue)
                        Text("Color Choise")
                            .padding(.leading, 10)
                    }
                }
                //Spin Duration
                NavigationLink(destination: SpinDurationView()) {
                    HStack{
                        //                        Label("Spin Time", systemImage: "timer")
                        Image(systemName: "timer")
                            .foregroundColor(.blue)
                        Text("Spin Time")
                            .padding(.leading,10)
                        Spacer()
                        Text("\(self.spinDuration) sn.")
                    }
                }
                
            }
        }
        .navigationBarTitle("Settings", displayMode: .inline)
        .onAppear {
            if var spinDurationItem = userDefault.getSpinDuration() {
                self.spinDuration = String(Int(spinDurationItem.duration))
            }
        }
    }
    
    func shareApp() {
        if let appURL = URL(string: "https://wheeldesicionspinwheel.godaddysites.com/privacy-policy") {
            let activityViewController = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
        }
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(shouldPlaySound: .constant(false), isSpeakResultActive: .constant(false), isDarkModEnabled: .constant(false), isVibration: .constant(false))
        
    }
}
