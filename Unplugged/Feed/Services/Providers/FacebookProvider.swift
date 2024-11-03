//
//  FacebookProvider.swift
//  Unplugged
//
//  Created by Noah Smith on 11/2/24.
//

import SwiftUI
import Foundation
import WebKit
import Alamofire

class FacebookProvider: ObservableObject {
    let cookieStore: HTTPCookieStorage
    
    @Published var authState: AuthenticationState = .loggedOut
    @Published var posts: [Post] = []
    
    var afterCursor: String
    
    init() {
        self.cookieStore = HTTPCookieStorage.shared
        self.afterCursor = ""
        
        refreshLoginState()
    }
    
    func refreshLoginState() {
        if let cookies = self.cookieStore.cookies(for: URL(string: "https://facebook.com")!) {
            for cookie in cookies {
                print(cookie)
                if cookie.name == "c_user" { // Could also be ds_user_id
                    authState = .loggedIn
                    return
                }
            }
        }

        authState = .loggedOut
        return
    }

    func fetchPosts(after: String, before: String, completionBlock: @escaping ([Post]) -> Void) {
        
    }
    
    func fetchNextPageOfPosts(completionBlock: @escaping ([Post]) -> Void) {
        self.fetchPosts(after: self.afterCursor, before: "", completionBlock: completionBlock)
    }
}
