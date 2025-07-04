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
        TabView {
            NavigationView {
                PlaylistView().environmentObject(playlist).navigationTitle("Playlist")
            }
            .tabItem {
                Label("Playlist", systemImage: "music.note.list")
            }
            
            NavigationView {
                SearchView().environmentObject(playlist).navigationTitle("Search")
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
        }
        .preferredColorScheme(.dark)
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var playlist: Playlist = Playlist(songs: [
        Song(id: 1, name: "Cowboys from Hell", artist: "Pantera", album: "Cowboys from Hell", link: "", image: "https://cdn-images.dzcdn.net/images/cover/b8e78de81ec615be64c9179589439d17/500x500-000000-80-0-0.jpg"),
        Song(id: 2, name: "The Best of Times", artist: "Dream Theater", album: "Black Clouds & Silver Linings", link: "", image: "https://upload.wikimedia.org/wikipedia/pt/7/77/220px-Dream_Theater_-_Black_Clouds_%26_Silver_Linings.jpg")
    ]);

    static var previews: some View {
        MainView().environmentObject(playlist)
    }
}
