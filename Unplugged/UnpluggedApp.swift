//
//  UnpluggedApp.swift
//  Unplugged
//
//  Created by Noah Smith on 11/2/24.
//

import SwiftUI

@main
struct UnpluggedApp: App {
    @StateObject var appSettings = AppSettings()
    
    let instagramProvider = InstagramProvider()
    let twitterProvider = TwitterProvider()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appSettings)
                .environmentObject(instagramProvider)
                .environmentObject(twitterProvider)
                .environmentObject(FeedService(instagramProvider: instagramProvider, twitterProvider: twitterProvider))
        }
    }
}
