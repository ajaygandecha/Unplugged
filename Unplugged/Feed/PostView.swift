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
 
    @EnvironmentObject var appSettings: AppSettings
    @State var isExpanded: Bool = false
    
    @ViewBuilder var postActions: some View {
        HStack {
            Button {
                //
            } label: {
                HStack {
                    Image(systemName: "heart")
                        .font(.system(size: 24))
                        .frame(width: 36, height: 36)
                        .foregroundColor(.accentColor)
                    
                    if (appSettings.showLikes) {
                        Text(String(post.likeCount))
                            .padding(.leading, -6)
                    }
                }
            }
            .buttonStyle(.plain)
            
            Button {
                //
            } label: {
                Image(systemName: "bubble")
                    .font(.system(size: 22))
                    .frame(width: 36, height: 36)
                    .foregroundColor(.accentColor)
                
            }
            .buttonStyle(.plain)
            
        }.padding(.horizontal, 10)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(post.userImage)
                    .resizable()
                    .frame(width: 48, height: 48)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 0) {
                    Text(post.username)
                        .bold()
                    HStack(spacing: 0) {
                        Text("from: ")
                            .foregroundStyle(Color.secondary)
                        Text(post.source.name).foregroundStyle(Color.secondary)
                            .fontWeight(.semibold)
                        Image(post.source.logo)
                            .resizable()
                            .frame(width: 18, height: 18)
                            .padding(.leading, 8)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            
            if (post.image != nil) {
                Image(post.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width)
                
                postActions
            }
            
            Text(post.body)
                .padding(.horizontal, 16)
                .lineLimit(isExpanded ? nil : post.image != nil ? 2 : 7)
                .overlay {
                    if isExpanded {
                        GeometryReader { textGeometry in
                            Button {
                                isExpanded.toggle()
                            } label: {
                                Text("less")
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
                                Text("...more")
                                    .foregroundStyle(Color.secondary)
                                    .background(Color.white)
                                    .padding(.horizontal, 16)
                                    
                            }
                            .frame(width: textGeometry.size.width, height: textGeometry.size.height, alignment: .bottomTrailing)
                        }
                    }
                    
                }
            
            if (post.image == nil) {
                postActions
            }
            
            Divider()
        }

    }
}

#Preview {
    GeometryReader { geometry in
        PostView(post: Post(likeCount: 10, userImage: "sample", username: "@KrisJordan", image: "post", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", source: .instagram), geometry: geometry).environmentObject(AppSettings())
    }
}
