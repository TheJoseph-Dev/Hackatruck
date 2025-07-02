//
//  iPlaylistApp.swift
//  iPlaylist
//
//  Created by Turma01-23 on 13/06/25.
//

import SwiftUI

@main
struct iPlaylistApp: App {
    @StateObject private var playlist: Playlist = Playlist(songs: [
        Song(name: "Cowboys from Hell", artist: "Pantera", album: "Cowboys from Hell", link: "", image: "https://cdn-images.dzcdn.net/images/cover/b8e78de81ec615be64c9179589439d17/500x500-000000-80-0-0.jpg"),
        Song(name: "The Best of Times", artist: "Dream Theater", album: "Black Clouds and Silver Linings", link: "", image: "https://upload.wikimedia.org/wikipedia/pt/7/77/220px-Dream_Theater_-_Black_Clouds_%26_Silver_Linings.jpg")
    ]);
    
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(playlist)
        }
    }
}
