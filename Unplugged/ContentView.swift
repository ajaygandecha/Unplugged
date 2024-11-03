//
//  ContentView.swift
//  Unplugged
//
//  Created by Noah Smith on 11/2/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var instagramProvider: InstagramProvider
    @EnvironmentObject var facebookProvider: FacebookProvider
    @EnvironmentObject var twitterProvider: TwitterProvider
    
    var body: some View {
        // Change to be connected to storage not authState
        if self.instagramProvider.authState == .loggedOut && self.facebookProvider.authState == .loggedOut &&
            self.twitterProvider.authState == .loggedOut { // Include facebook here
            OnboardingView()
        } else {
            FeedView()
        }
    }
}

#Preview {
    ContentView()
}
