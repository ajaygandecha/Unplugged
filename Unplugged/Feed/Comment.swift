//
//  Comment.swift
//  Unplugged
//
//  Created by JadeKeegan on 11/2/24.
//

import Foundation

struct Comment: Identifiable {
    let id = UUID()
    let userImage : String
    let username: String
    let body: String
}
