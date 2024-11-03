//
//  FeedService.swift
//  Unplugged
//
//  Created by Noah Smith on 11/2/24.
//

import SwiftUI

class FeedService: ObservableObject {
    
    @AppStorage("instagramFriends") var instagramFriends: [String] = []
    @AppStorage("facebookFriends") var facebookFriends: [String] = []
    @AppStorage("twitterFriends") var twitterFriends: [String] = []

    @Published private var rawFeed: [Post] = []
    
    var feedTimestamps: Set<Int> {
        return Set(feed.map { $0.timestamp })
    }
    
    var feed: [Post] {
        let instagramFriendsSet = Set(instagramFriends)
        let facebookFriendsSet = Set(instagramFriends)
        let twitterFriendsSet = Set(instagramFriends)

        return self.rawFeed
            .sorted(by: { $0.timestamp > $1.timestamp })
            .filter {
                ($0.source == .instagram && (!appSettings.filterInstagramFriends || (appSettings.filterInstagramFriends && instagramFriendsSet.contains($0.username))))
                || ($0.source == .facebook && (!appSettings.filterFacebookFriends || (appSettings.filterFacebookFriends && facebookFriendsSet.contains($0.username))))
                || ($0.source == .twitter && (!appSettings.filterTwitterFriends || (appSettings.filterTwitterFriends && twitterFriendsSet.contains($0.username))))
            }
            .map { post in
                var newPost = post
                newPost.media = post.media.filter { mediaItem in
                    return !appSettings.hideVideos || mediaItem.postType == .photo
                }
                return newPost
            }
    }
    
    /// Calculates the ID of the post that should trigger a reload
    var nextPageLoadThresholdPostId: UUID? {
        if self.feed.count < 4 || self.feed.count > 100 {
            return nil
        }
        
        // We will load data at the fifth to last post.
        let offset = self.rawFeed.count - 4
        return self.feed[offset].id
    }
    
    var appSettings: AppSettings!
    var instagramProvider: InstagramProvider!
    var twitterProvider: TwitterProvider!
    var facebookProvider: FacebookProvider!

    init(instagramProvider: InstagramProvider, twitterProvider: TwitterProvider, facebookProvider: FacebookProvider, appSettings: AppSettings) {
        self.instagramProvider = instagramProvider
        self.twitterProvider = twitterProvider
        self.facebookProvider = facebookProvider
        self.facebookProvider.feedService = self
        self.appSettings = appSettings

        self.reset()
        self.fetchNext()
    }
    
    // rn needs to call instagram provider fetch posts
    
    func reset() {
        self.instagramProvider.reset()
    }
    
    func fetchNext() {
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
