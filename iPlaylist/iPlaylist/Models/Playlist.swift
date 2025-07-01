//
//  Playlist.swift
//  iPlaylist
//
//  Created by Turma01-23 on 13/06/25.
//

import Foundation

class Playlist: ObservableObject {
    @Published var songs: Set<Song> = Set<Song>(); // Makes this member observable
    
    init(songs: Set<Song>) {
        self.songs = songs
    }
    
    func addSong(song: Song) {
        songs.insert(song);
    }
    
    func removeSong(song: Song) -> Bool {
        if let _ = songs.remove(song) { return true; }
        return false;
    }
}
