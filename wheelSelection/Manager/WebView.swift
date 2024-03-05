//
//  WebView.swift
//  selectionWheel
//
//  Created by Hakan ERDOĞMUŞ on 13.02.2024.
//

import WebKit
import SwiftUI

// WebView kontrolünü içerecek SwiftUI View'ı oluştur
    struct WebView: UIViewRepresentable {
        let urlString: String

        func makeUIView(context: Context) -> WKWebView {
            let webView = WKWebView()
            webView.navigationDelegate = context.coordinator
            return webView
        }

        func updateUIView(_ uiView: WKWebView, context: Context) {
            if let url = URL(string: urlString) {
                let request = URLRequest(url: url)
                uiView.load(request)
            }
        }

        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        class Coordinator: NSObject, WKNavigationDelegate {
            var parent: WebView

            init(_ parent: WebView) {
                self.parent = parent
            }

            // Web sayfası yüklenirken gerçekleşen olayları işleme yönelik kodlar eklenebilir
        }
    }

  
