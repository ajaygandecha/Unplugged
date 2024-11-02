//
//  HomeView.swift
//  Unplugged
//
//  Created by Ajay Gandecha on 11/2/24.
//

import SwiftUI

struct FeedView: View {
    var posts: [Post] = []
    
    @EnvironmentObject var feedService: FeedService
    
    @State private var filterSelection = "All Posts"
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    ZStack {
                        ScrollView {
                            ForEach(
                                filterSelection == "All Posts" ? feedService.feed : posts.filter { post in post.source.name == filterSelection}
                            ) {
                                post in
                                PostView(post: post, geometry: geometry).padding(.top, 8)
                            }
                        }
                    }
                }
                .navigationTitle("Unplugged")
                .toolbar {
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack {
                            Menu {
                                Picker("Filter Picker", selection: $filterSelection) {
                                    Text("All Posts").tag("All Posts")
                                    ForEach(ServiceType.allCases) { serviceType in
                                        Text(serviceType.name).tag(serviceType.name)
                                    }}
                            } label: {
                                Image(systemName: "slider.horizontal.3")
                            }

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
}

#Preview {
    FeedView(posts: [
        Post(likeCount: 10, userImage: "sample", username: "@krisjordan", images: ["post", "tallpost"], body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", source: .instagram),
        Post(likeCount: 15, userImage: "sample", username: "@krisjordan", images: ["post"], body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", source: .facebook),
        Post(likeCount: 40, userImage: "sample", username: "@krisjordan", images: ["post"], body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", source: .instagram)]).environmentObject(AppSettings())
}
