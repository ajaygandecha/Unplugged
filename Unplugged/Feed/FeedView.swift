//
//  HomeView.swift
//  Unplugged
//
//  Created by Ajay Gandecha on 11/2/24.
//

import SwiftUI

struct FeedView: View {
    var posts: [Post] = []

    @EnvironmentObject var instagramProvider: InstagramProvider
    @EnvironmentObject var feedService: FeedService
    
    // Replace with EnvironmentObject providers
    @State private var isFacebookConnected: Bool = false
    @State private var isTwitterConnected: Bool = false

    @State private var filterSelection = "All Posts"
    @State private var showSettings: Bool = false

    var connectedApps: [String] {
        var apps: [String] = []
        if instagramProvider.authState == .loggedIn {
            apps.append("Instagram")
        }
        if isFacebookConnected {
            apps.append("Facebook")
        }
        if isTwitterConnected {
            apps.append("Twitter")
        }
        return apps
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(alignment: .leading, spacing: 0) {
                    ZStack {
                        ScrollView {
                            ForEach(
                                filterSelection == "All Posts" ? feedService.feed : feedService.feed.filter { post in post.source.name == filterSelection}
                            ) {
                                post in
                                PostView(post: post, geometry: geometry).padding(.top, 8)
                            }
                        }
                    }
                    Divider()
                    HStack {
                        Button {
                            filterSelection = "All Posts"
                        } label: {
                            let active = filterSelection == "All Posts";

                            Image(systemName: "house")
                                .font(.system(size: 24))
                                .frame(width: 36, height: 36)
                                .foregroundColor(.accentColor)
                                .if(active) { $0.overlay(Rectangle().frame(width: nil, height: 2, alignment: .top).foregroundColor(Color.blue), alignment: .bottom)
                                }
                        }
                        .buttonStyle(.plain)


                        ForEach(ServiceType.allCases.filter { connectedApps.contains($0.name) }) { serviceType in
                            Spacer()
                            Button {
                                filterSelection = serviceType.name
                            } label: {
                                let active = filterSelection == serviceType.name;

                                Image(serviceType.logo + ".plain")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .padding(6)
                                    .foregroundColor(.accentColor)
                                    .if(active) { $0.overlay(Rectangle().frame(width: nil, height: 2, alignment: .top).foregroundColor(Color.blue), alignment: .bottom)
                                    }
                            }.buttonStyle(.plain)
                        }
                    }
                    .padding(
                        EdgeInsets(top: 8, leading: connectedApps.count == 1 ? 80 : 40, bottom: 0, trailing: connectedApps.count == 1 ? 80 : 40)
                    )
                    .navigationTitle("Unplugged")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            HStack {
                                Button {
                                    showSettings = true
                                } label: {
                                    Image(systemName: "gear")
                                }
                            }
                        }
                    }
                    .sheet(isPresented: $showSettings) {
                        SettingsView()
                    }
                }
            }
        }
    }
}

//
//#Preview {
//    FeedView(posts: [
//        Post(liked: false, likeCount: 10, userImage: "sample", username: "@krisjordan", media: [MediaItem(url: "post", postType: .photo), MediaItem(url: "tallpost", postType: .photo)], body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", source: .instagram),
//        Post(liked: true, likeCount: 15, userImage: "sample", username: "@krisjordan", media: [MediaItem(url: "post", postType: .photo)], body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", source: .facebook),
//        Post(liked: false, likeCount: 40, userImage: "sample", username: "@krisjordan", media: [MediaItem(url: "post", postType: .photo)], body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", source: .instagram)]).environmentObject(AppSettings())
//}
