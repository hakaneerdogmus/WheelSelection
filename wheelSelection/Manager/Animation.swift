//
//  Animation.swift
//  selectionWheel
//
//  Created by Hakan ERDOĞMUŞ on 9.02.2024.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var filename: String
    var onAnimationComplete: () -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let animationView = LottieAnimationView(name: filename)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])

        animationView.play { completed in
            onAnimationComplete()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            animationView.stop()
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
