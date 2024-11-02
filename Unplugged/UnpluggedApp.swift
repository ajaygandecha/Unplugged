//
//  UnpluggedApp.swift
//  Unplugged
//
//  Created by Noah Smith on 11/2/24.
//

import SwiftUI

@main
struct UnpluggedApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(InstagramProvider())
        }
    }
}
