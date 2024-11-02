//
//  WebView.swift
//  Unplugged
//
//  Created by Ajay Gandecha on 11/2/24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    let url: URL
    
    let webView: WKWebView = WKWebView()
    
    func makeUIView(context: Context) -> WKWebView {
        return self.webView
    }
    

    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func readCookies() {
        return webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
            print(cookies)
        }
    }
    
    class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        // Delegate methods go here
        

//        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void) {
//            let targetURL = "https://www.apple.com"
//            
//            if let url = navigationAction.request.url?.absoluteString, url == targetURL {
//                // Close the web view if it navigates to the target URL
//                // dismiss(animated: true)
//                decisionHandler(.cancel) // Cancel the navigation
//            } else {
//                decisionHandler(.allow) // Allow other navigations
//            }
//        }
//        
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

}

