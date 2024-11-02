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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appSettings)
                .environmentObject(instagramProvider)
                .environmentObject(FeedService(instagramProvider: instagramProvider))
        }
    }
}
