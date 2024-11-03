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
    var facebookProvider: FacebookProvider!

    init(instagramProvider: InstagramProvider, twitterProvider: TwitterProvider, facebookProvider: FacebookProvider) {
        self.instagramProvider = instagramProvider
        self.twitterProvider = twitterProvider
        self.facebookProvider = facebookProvider

        self.fetch()
    }
    
    // rn needs to call instagram provider fetch posts
    
    func fetch() {
        fetchInstagram()
        fetchTwitter()
        fetchFacebook()
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
    
    func fetchFacebook() {
        if (self.facebookProvider.authState == .loggedIn) {
            self.facebookProvider.fetchNextPageOfPosts { posts in
                self.rawFeed.append(contentsOf: posts)
            }
        }
    }
}
