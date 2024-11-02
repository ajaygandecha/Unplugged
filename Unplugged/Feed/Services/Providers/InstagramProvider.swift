//
//  InstagramProvider.swift
//  Unplugged
//
//  Created by Noah Smith on 11/2/24.
//

import SwiftUI
import Foundation
import WebKit

class InstagramProvider: ObservableObject { // Implement some sort of data provider protocol later on
    let cookieStore: HTTPCookieStorage
    
    init() {
        self.cookieStore = HTTPCookieStorage.shared
    }
    
    func dumpCookies() {
//        print(self.cookieStore.cookies)
        print(self.isLoggedIn())
    }
    
    func isLoggedIn() -> Bool {
        if let cookies = self.cookieStore.cookies(for: URL(string: "https://instagram.com")!) {
            for cookie in cookies {
                if cookie.name == "sessionid" { // Could also be ds_user_id
                    return true
                }
            }
        }
        
        return false
    }
}
