//
//  CommentItemView.swift
//  Unplugged
//
//  Created by Jade Keegan on 11/2/24.
//

import SwiftUI

struct CommentItemView: View {
    var comment: Comment!
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Image(comment.userImage)
                    .resizable()
                    .frame(width: 48, height: 48)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text(comment.username)
                        .bold()
                    Text(comment.body)
                }
            }
        }
    }
}

#Preview {
    CommentItemView(comment:Comment(userImage: "sample", username: "@krisjordan", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."))
}
