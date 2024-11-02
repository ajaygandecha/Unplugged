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
        self.rawFeed
        //self.rawFeed.sorted(by: { $0.date < $1.date })
    }
    
    var instagramProvider: InstagramProvider!
    
    init(instagramProvider: InstagramProvider) {
        self.instagramProvider = instagramProvider
        
        self.fetch()
    }
    // rn needs to call instagram provider fetch posts
    
    func fetch() {
        
        // Load instagram posts
        self.instagramProvider.fetchPosts(after: "", before: "") { posts in
            self.rawFeed.append(contentsOf: posts)
        }
    }
}
