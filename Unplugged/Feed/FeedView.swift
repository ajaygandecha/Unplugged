//
//  HomeView.swift
//  Unplugged
//
//  Created by Ajay Gandecha on 11/2/24.
//

import SwiftUI

struct FeedView: View {
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    Divider()
                    PostView(post:Post(userImage: "sample", username: "@krisjordan", image: "post", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."), geometry: geometry)
                        .padding(.top, 8)
                    PostView(post:Post(userImage: "sample", username: "@krisjordan", image: "post", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."), geometry: geometry)
                        .padding(.top, 8)
                    PostView(post:Post(userImage: "sample", username: "@krisjordan", image: "post", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."), geometry: geometry)
                        .padding(.top, 8)
                }
                .navigationTitle("Unplugged")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {}) {
                            NavigationLink {
                                SettingsView()
                            } label: {
                                Image(systemName: "gear")
                            }

                        }

                    }
                }
            }
        }
    }
}

#Preview {
    FeedView()
}
