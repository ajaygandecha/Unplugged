//
//  FeedService.swift
//  Unplugged
//
//  Created by Noah Smith on 11/2/24.
//

import Foundation

class FeedService: ObservableObject {
    
    @Published private var rawFeed: [Post] = []
    
    var feed: [Post] {
//        self.rawFeed
        self.rawFeed.sorted(by: { $0.timestamp > $1.timestamp })
    }
    
    var instagramProvider: InstagramProvider!
    var twitterProvider: TwitterProvider!

    init(instagramProvider: InstagramProvider, twitterProvider: TwitterProvider) {
        self.instagramProvider = instagramProvider
        self.twitterProvider = twitterProvider

        self.fetch()
    }
    
    // rn needs to call instagram provider fetch posts
    
    func fetch() {
        fetchInstagram()
        fetchTwitter()
    }
    
    func fetchInstagram() {
        if (self.instagramProvider.authState == .loggedIn) {
            self.instagramProvider.fetchNextPageOfPosts { posts in
                self.rawFeed.append(contentsOf: posts)
            }
        }
    }
    
    func fetchTwitter() {
        if (self.twitterProvider.authState == .loggedIn) {
            self.twitterProvider.fetchNextPageOfPosts { posts in
                self.rawFeed.append(contentsOf: posts)
            }
        }
    }
}
