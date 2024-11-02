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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(InstagramProvider())
                .environmentObject(appSettings)
        }
    }
}
