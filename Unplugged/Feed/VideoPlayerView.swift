//
//  VideoPlayerView.swift
//  Unplugged
//
//  Created by Noah Smith on 11/2/24.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    
    var url: URL!
    @State var player = AVPlayer()
    
    var body: some View {
        VideoPlayer(player: player)
        .task {
            self.player = AVPlayer(url: url)
            player.play()
        }
    }
}

#Preview {
    VideoPlayerView()
}