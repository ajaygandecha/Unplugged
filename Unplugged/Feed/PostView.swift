//
//  PostView.swift
//  Unplugged
//
//  Created by Ajay Gandecha on 11/2/24.
//

import SwiftUI

struct PostView: View {
    
    var post: Post!
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                HStack {
                    Image(post.userImage)
                        .resizable()
                        .frame(width: 48, height: 48)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                    VStack(alignment: .leading) {
                        Text(post.username)
                            .bold()
                        HStack(spacing: 0) {
                            Text("from: ")
                                .foregroundStyle(Color.secondary)
                            Text("Instagram")
                                .foregroundStyle(Color.secondary)
                                .fontWeight(.semibold)
                            Image("instagram")
                                .resizable()
                                .frame(width: 18, height: 18)
                                .padding(.leading, 8)
                        }
                    }
                }
                .padding(.horizontal, 16)

                Image("post")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width)
                
                HStack {
                    Button {
                        //
                    } label: {
                        Image(systemName: "heart")
                    }

                }
                Divider()
            }

        }
    }
}

#Preview {
    PostView(post: Post(userImage: "sample", username: "@KrisJordan"))
}
