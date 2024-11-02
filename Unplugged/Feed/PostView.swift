//
//  PostView.swift
//  Unplugged
//
//  Created by Ajay Gandecha on 11/2/24.
//

import SwiftUI
import AVKit

struct PostView: View {
    
    var post: Post!
    var geometry: GeometryProxy!
    
    var hasMedia: Bool {
        post.media.count > 0
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
                        Text(post.likeCount.compacted)
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
            
            if (hasMedia) {
                let firstMediaItem = post.media.first!
                let heightMultiple = Double(firstMediaItem.height) / Double(firstMediaItem.width)
                
                TabView {
                    ForEach(post.media, id: \.url) { media in
                        switch media.postType {
                            case .photo:
                            
                            AsyncImage(url: URL(string: media.url)!) { result in
                                result.image?
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)

                            }
                            .frame(width: geometry.size.width, height: geometry.size.width)

                            
                            case .video:
                                VideoPlayerView(url: URL(string: media.url)!)
                        }
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .automatic))
                .frame(width: geometry.size.width, height: geometry.size.width * heightMultiple)
                
                postActions
            }
            
            Text(post.body)
                .padding(.horizontal, 16)
                .lineLimit(isExpanded ? nil : hasMedia ? 2 : 7)
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
            
            if (!hasMedia) {
                postActions
            }
            
            Divider()
        }

    }
}

//#Preview {
//    GeometryReader { geometry in
//        PostView(post: Post(likeCount: 10, userImage: "sample", username: "@KrisJordan", media: [
//            MediaItem(url: "squarepost", postType: .photo),
//            MediaItem(url: "post", postType: .photo),
//            MediaItem(url: "tallpost", postType: .photo),
//            MediaItem(url: "https://scontent.cdninstagram.com/o1/v/t16/f2/m69/AQNTtQnQEvVWKV_9Rb4Wa5MXOIH-hf74ORe0NeLhOQSr0u0A0CpoQAUUP8pN27QF9gv_sFHFeGOzeReEBb7R7ev5.mp4?efg=eyJ4cHZfYXNzZXRfaWQiOjkyNjM2NTA5NjA2NTcxMiwidmVuY29kZV90YWciOiJ4cHZfcHJvZ3Jlc3NpdmUuSU5TVEFHUkFNLkNBUk9VU0VMX0lURU0uQzMuMTA4MC5kYXNoX2Jhc2VsaW5lXzEwODBwX3YxIn0&_nc_ht=scontent.cdninstagram.com&_nc_cat=108&strext=1&vs=150906308ef8f165&_nc_vs=HBksFQIYOnBhc3N0aHJvdWdoX2V2ZXJzdG9yZS9HTlk3SkFPWEJxWXBSRndGQUNwSUtscm9TT0VWYnBSMUFBQUYVAALIAQAVAhg6cGFzc3Rocm91Z2hfZXZlcnN0b3JlL0dFVUV3QnN4SllacnhDa09BQ1BYdTdkRmJnNEVia1lMQUFBRhUCAsgBACgAGAAbAogHdXNlX29pbAExEnByb2dyZXNzaXZlX3JlY2lwZQExFQAAJuDq3efFoaUDFQIoAkMzLBdAEAAAAAAAABgWZGFzaF9iYXNlbGluZV8xMDgwcF92MREAde4HAA&ccb=9-4&oh=00_AYCJkgtBzyD5rhXRhPHlKn-r-dOxUmv3d06bY0tcxV1wtQ&oe=672845E1&_nc_sid=1d576d", postType: .video)
//        ], body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", source: .instagram), geometry: geometry).environmentObject(AppSettings())
//    }
//}
