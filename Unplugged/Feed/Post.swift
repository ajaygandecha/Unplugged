//
//  Post.swift
//  Unplugged
//
//  Created by Ajay Gandecha on 11/2/24.
//

import Foundation

struct Post: Identifiable {
    let id = UUID()
    var liked: Bool
    var likeCount: Int
    let userImage : String
    let username: String
    var media: [MediaItem]
    let body: String
    let source: ServiceType
    let timestamp: Int
}

enum MediaType {
    case photo, video
}

struct MediaItem {
    let url: String
    let postType: MediaType
    let width: Int
    let height: Int
}
