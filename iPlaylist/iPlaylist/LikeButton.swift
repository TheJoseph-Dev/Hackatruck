//
//  LikeButton.swift
//  iPlaylist
//
//  Created by Turma01-23 on 19/06/25.
//

import SwiftUI

struct LikeButton: View {
    @EnvironmentObject var playlist: Playlist;
    let song: Song
    var body: some View {
        if(playlist.songs.contains(song)) {
            Button(action: {
                let _ = playlist.removeSong(song: song);
            }) {
                Image(systemName: "heart.fill")
            }
            .buttonStyle(BorderlessButtonStyle()) // Avoid bugging the cell
        }
        else {
            Button(action: {
                playlist.addSong(song: song);
            }) {
                Image(systemName: "heart")
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
}
