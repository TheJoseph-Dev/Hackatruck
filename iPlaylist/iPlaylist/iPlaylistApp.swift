//
//  iPlaylistApp.swift
//  iPlaylist
//
//  Created by Turma01-23 on 13/06/25.
//

import SwiftUI

@main
struct iPlaylistApp: App {
    @StateObject private var playlist: Playlist = Playlist(songs: [Song(name: "Cowboys from Hell", artist: "Pantera", album: "Cowboys from Hell", link: "", image: "")]);
    
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(playlist)
        }
    }
}
