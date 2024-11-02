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
        FeedView()
    }
}

#Preview {
    ContentView()
}
