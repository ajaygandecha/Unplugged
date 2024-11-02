//
//  CommentsView.swift
//  Unplugged
//
//  Created by Jade Keegan on 11/2/24.
//

import SwiftUI

struct CommentsView: View {
    var comments: [Comment] = []
    
    var body: some View {
        List {
            Section {
                ForEach(comments) { comment in
                    CommentItemView(comment: comment).alignmentGuide(.listRowSeparatorLeading) { _ in return 0 }
                }
                
            } header: {
                Text("Comments")
            }
        }.listStyle(.inset)
    }
}

#Preview {
    CommentsView(comments:[Comment(userImage: "sample", username: "@krisjordan", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),Comment(userImage: "sample", username: "@krisjordan", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")])
}
