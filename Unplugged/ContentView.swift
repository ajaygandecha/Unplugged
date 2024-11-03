//
//  ContentView.swift
//  Unplugged
//
//  Created by Noah Smith on 11/2/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var ig: InstagramProvider
    
    var body: some View {
        // Change to be connected to storage not authState
        if self.ig.authState == .loggedOut { // Include facebook here
            OnboardingView()
        } else {
            FeedView()
        }
    }
}

#Preview {
    ContentView()
}
