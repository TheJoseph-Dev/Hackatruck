//
//  PlaylistStatusView.swift
//  iPlaylist
//
//  Created by Turma01-23 on 16/06/25.
//

import SwiftUI

struct PlaylistStatusView: View {
    @EnvironmentObject var playlist: Playlist;
    
    func mostPopularArtist() -> String {
        var artist = "";
        var curCount = 0;
        var count = Dictionary<String, Int>()
        for song in playlist.songs {
            if let value = count[song.artist] { count.updateValue(value+1, forKey: song.artist) }
            else { count.updateValue(1, forKey: song.artist) }
            if(curCount >= count[song.artist]!) { continue }
            artist = song.artist
            curCount = count[song.artist]!
        }
        return artist;
    }
    
    var body: some View {
        VStack {
            Text("Most Popular Artist:\n\(mostPopularArtist())")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top)
                .padding(.top)
            Spacer()
        }
    }
}

//#Preview {
//    PlaylistStatusView()
//}
