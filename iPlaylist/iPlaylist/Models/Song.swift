//
//  Song.swift
//  iPlaylist
//
//  Created by Turma01-23 on 13/06/25.
//

import Foundation

struct Song: Identifiable, Hashable {
    let id: UUID = UUID();
    let name: String;
    let artist: String;
    let album:  String;
    private(set) var popularity: Int32 = 0;
    private(set) var plays: Int32 = 0;
    let link: String;
    let image: String;
    init(name: String, artist: String, album: String, link: String, image: String) {
        self.name = name
        self.artist = artist
        self.album = album
        self.link = link
        self.image = image;
    }
    
}
