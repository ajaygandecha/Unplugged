//
//  Post.swift
//  Unplugged
//
//  Created by Ajay Gandecha on 11/2/24.
//

import Foundation

struct Post: Identifiable {
    let id = UUID()
    let likeCount: Int
    let userImage : String
    let username: String
    let image: String?
    let body: String
    let source: ServiceType
}
