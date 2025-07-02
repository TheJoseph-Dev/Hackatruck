//
//  AddSongView.swift
//  iPlaylist
//
//  Created by Turma01-23 on 13/06/25.
//

import SwiftUI

struct AddSongView: View {
    @EnvironmentObject var playlist: Playlist;
    @Environment(\.dismiss) var dismiss;
    @State var songName: String = "";
    @State var artistName: String = "";
    @State var albumTitle: String = "";
    @State var songLink: String = "";
    @State var imageURL: String = "";
    var body: some View {
        VStack{
            Text("Add a new song!");
            TextField("Name", text: $songName).padding()
            TextField("Artist", text: $artistName).padding()
            TextField("Album", text: $albumTitle).padding()
            TextField("Link", text: $songLink).padding()
            TextField("Image URL", text: $imageURL).padding()
            
            Spacer()
            
            Button("Add") {
                playlist.addSong(song: Song(name: songName, artist: artistName, album: albumTitle, link: songLink, image: imageURL))
                dismiss();
            }
        } .padding()
    }
}

#Preview {
    AddSongView()
}
