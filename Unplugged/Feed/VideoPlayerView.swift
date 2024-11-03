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
        .onTapGesture {
            switch player.timeControlStatus {
            case .paused:
                player.play()
            case .waitingToPlayAtSpecifiedRate:
                player.play()
            case .playing:
                player.pause()
            @unknown default:
                fatalError("I am not a teapot, but I am a coffee kettle. Also this error is on line 31 in VideoPLayerView!")
            }
        }
    }
}

#Preview {
    VideoPlayerView()
}
