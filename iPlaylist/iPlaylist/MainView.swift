//
//  ContentView.swift
//  iPlaylist
//
//  Created by Turma01-23 on 13/06/25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var playlist: Playlist;
    
    var body: some View {
        NavigationView {
            VStack {
                Text("My Playlist")
                                .font(.largeTitle)
                                .padding()
                
                List {
                    ForEach(Array(playlist.songs).sorted(by: { return $0.name < $1.name }), id: \.id) { song in
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
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                // Navigation to another view
                NavigationLink("Add Song", destination: AddSongView().environmentObject(playlist))
            }
        }.preferredColorScheme(.dark)
    }
}

struct MainView_Previews: PreviewProvider {
    static var playlist: Playlist = Playlist(songs: [
        Song(name: "Cowboys from Hell", artist: "Pantera", album: "Cowboys from Hell", link: "", image: "https://cdn-images.dzcdn.net/images/cover/b8e78de81ec615be64c9179589439d17/500x500-000000-80-0-0.jpg"),
        Song(name: "The Best of Times", artist: "Dream Theater", album: "Black Clouds & Silver Linings", link: "", image: "https://upload.wikimedia.org/wikipedia/pt/7/77/220px-Dream_Theater_-_Black_Clouds_%26_Silver_Linings.jpg")
    ]);

    static var previews: some View {
        MainView()
            .environmentObject(playlist)
    }
}
