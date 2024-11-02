//
//  PostView.swift
//  Unplugged
//
//  Created by Ajay Gandecha on 11/2/24.
//

import SwiftUI

struct PostView: View {
    
    var post: Post!
    var geometry: GeometryProxy!
    
    @State var isExpanded: Bool = false
    
    var body: some View {
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
                Spacer()
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
                        .font(.system(size: 24))
                        .frame(width: 36, height: 36)
                }
                
                Button {
                    //
                } label: {
                    Image(systemName: "bubble")
                        .font(.system(size: 22))
                        .frame(width: 36, height: 36)
                }

            }
            .padding(.horizontal, 16)
            
            Text(post.body)
                .padding(.horizontal, 16)
                .lineLimit(isExpanded ? nil : 2)
                .overlay {
                    if isExpanded {
                        GeometryReader { textGeometry in
                            Button {
                                isExpanded.toggle()
                            } label: {
                                Text("  less...")
                                    .foregroundStyle(Color.secondary)
                                    .background(Color.white)
                                    .padding(.horizontal, 16)
                                    
                            }
                            .frame(width: textGeometry.size.width, height: textGeometry.size.height, alignment: .bottomTrailing)
                        }
                    } else {
                        GeometryReader { textGeometry in
                            Button {
                                isExpanded.toggle()
                            } label: {
                                Text("  more...")
                                    .foregroundStyle(Color.secondary)
                                    .background(Color.white)
                                    .padding(.horizontal, 16)
                                    
                            }
                            .frame(width: textGeometry.size.width, height: textGeometry.size.height, alignment: .bottomTrailing)
                        }
                    }
                    
                }
                
            
            Divider()
        }

    }
}

#Preview {
    GeometryReader { geometry in
        PostView(post: Post(userImage: "sample", username: "@KrisJordan", image: "post", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."), geometry: geometry)

    }
}
