//
//  SendFeedbackView.swift
//  selectionWheel
//
//  Created by Hakan ERDOĞMUŞ on 9.01.2024.
//

import SwiftUI
import MessageUI


//MARK: Mail Gönderme View
// Bu view emilatörde çalışmıyor 
struct SendFeedbackView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = MFMailComposeViewController
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let viewController = MFMailComposeViewController()
        viewController.setSubject("Wheel App Feedback")
        viewController.setToRecipients(["hakan.erdogmustech@gmail.com"])
        viewController.setMessageBody("Hello, ", isHTML: false)
        viewController.mailComposeDelegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
        // Güncelleme gerekmiyor
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            // E-posta gönderme ekranını kapat
            controller.dismiss(animated: true)
        }
    }
}


