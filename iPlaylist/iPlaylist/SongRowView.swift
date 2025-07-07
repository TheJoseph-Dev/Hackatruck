//
//  SongRowView.swift
//  iPlaylist
//
//  Created by Turma01-23 on 19/06/25.
//

import SwiftUI

struct SongRowView: View {
    @EnvironmentObject var playlist: Playlist;
    let song: Song

    var body: some View {
        ZStack { // Avoid NavigationLink default buttons and blocking behaviours maintaining the row clickable
            NavigationLink(destination: PlaySongView(song: song).environmentObject(playlist)) {}
                .opacity(0)
                .allowsHitTesting(false)
            
            HStack {
                AsyncImage(url: URL(string: song.cover)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView().progressViewStyle(.circular)
                }
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(song.name)
                        .font(.headline)
                    Text(song.artist)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.leading)
                
                Spacer()
                
                LikeButton(song: song).environmentObject(playlist)
            }
            .padding(.vertical, 4)
        }
    }
}
