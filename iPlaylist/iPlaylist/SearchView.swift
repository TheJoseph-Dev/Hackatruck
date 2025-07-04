//
//  SearchView.swift
//  iPlaylist
//
//  Created by Turma01-23 on 16/06/25.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var playlist: Playlist;
    private let songs: [Song] = [
        Song(id: 1, name: "Cowboys from Hell", artist: "Pantera", album: "Cowboys from Hell", link: "", image: "https://cdn-images.dzcdn.net/images/cover/b8e78de81ec615be64c9179589439d17/500x500-000000-80-0-0.jpg"),
        Song(id: 2, name: "The Best of Times", artist: "Dream Theater", album: "Black Clouds & Silver Linings", link: "", image: "https://upload.wikimedia.org/wikipedia/pt/7/77/220px-Dream_Theater_-_Black_Clouds_%26_Silver_Linings.jpg"),
        Song(id: 3, name: "As I am", artist: "Dream Theater", album: "Train of Throught", link: "", image: "https://upload.wikimedia.org/wikipedia/pt/2/29/Train_of_thought_dream_theater.jpg")
    ]
    
    var body: some View {
        List {
            ForEach(songs.sorted(by: { return $0.name < $1.name }), id: \.id) { song in
                HStack {
                    AsyncImage(url: URL(string: song.image), content: {
                        $0.image?.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 80, maxHeight: 80)
                            .clipShape(Circle())
                    })
                    
                    Text(song.name)
                        .font(.headline)
                    Spacer()
                    Text(song.artist)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    if(playlist.songs.contains(song)) {
                        Button(action: {
                            let _ = playlist.removeSong(song: song);
                        }) {
                            Image(systemName: "heart.fill")
                        }
                    }
                    else {
                        Button(action: {
                            playlist.addSong(song: song);
                        }) {
                            Image(systemName: "heart")
                        }
                    }
                    
                }
                .padding(.vertical, 4)
            }
        }
        .padding(.top)
        .padding(.top)
    }
}

//#Preview {
//    SearchView()
//}
