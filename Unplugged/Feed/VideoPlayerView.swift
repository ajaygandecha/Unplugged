//
//  VideoPlayerView.swift
//  Unplugged
//
//  Created by Noah Smith on 11/2/24.
//

import SwiftUI
import AVKit
import VideoPlayer

/// Implements a video player view using a async, caching video player.
struct VideoPlayerView: View {
    
    var url: URL!
    @State var play: Bool = true
    
    var body: some View {
        VideoPlayer(url: url, play: $play)
            .autoReplay(true)
            .onTapGesture {
                self.play.toggle()
            }
    }
}

#Preview {
    VideoPlayerView()
}
