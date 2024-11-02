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
    
    var hasImages: Bool {
        post.images.count > 0
    }
 
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
                
                AsyncImage(url: URL(string: post.userImage)) { result in
                    result.image?
                        .resizable()
                        .frame(width: 48, height: 48)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())

                }
                .frame(width: 48, height: 48)
                
//                AsyncImage(url: URL(string: post.username)!)
//                    .resizable()
//                    .frame(width: 48, height: 48)
//                    .aspectRatio(contentMode: .fit)
//                    .clipShape(Circle())
                
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
            
            if (hasImages) {
                let firstImage = UIImage(named: post.images[0])!
                let heightMultiple = firstImage.size.height / firstImage.size.width
                
                TabView {
                    ForEach(post.images, id: \.self) {
                        imageUrl in
                        
                        AsyncImage(url: URL(string: imageUrl)!) { result in
                            result.image?
                                .resizable()
                                .aspectRatio(contentMode: .fill)

                        }
                        .frame(width: geometry.size.width, height: geometry.size.width)

                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .automatic))
                .frame(width: geometry.size.width, height: geometry.size.width * heightMultiple)
                
                postActions
            }
            
            Text(post.body)
                .padding(.horizontal, 16)
                .lineLimit(isExpanded ? nil : hasImages ? 2 : 7)
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
            
            if (!hasImages) {
                postActions
            }
            
            Divider()
        }

    }
}

#Preview {
    GeometryReader { geometry in
        PostView(post: Post(likeCount: 10, userImage: "sample", username: "@KrisJordan", images: ["squarepost", "post", "tallpost"], body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", source: .instagram), geometry: geometry).environmentObject(AppSettings())
    }
}
