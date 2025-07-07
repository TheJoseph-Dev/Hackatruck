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
        Song(id: 1, name: "Cowboys from Hell", artist: "Pantera", album: "Cowboys from Hell", link: "", cover: "https://cdn-images.dzcdn.net/images/cover/b8e78de81ec615be64c9179589439d17/500x500-000000-80-0-0.jpg"),
        Song(id: 2, name: "The Best of Times", artist: "Dream Theater", album: "Black Clouds & Silver Linings", link: "", cover: "https://upload.wikimedia.org/wikipedia/pt/7/77/220px-Dream_Theater_-_Black_Clouds_%26_Silver_Linings.jpg"),
        Song(id: 3, name: "As I am", artist: "Dream Theater", album: "Train of Throught", link: "", cover: "https://upload.wikimedia.org/wikipedia/pt/2/29/Train_of_thought_dream_theater.jpg"),
        Song(id: 4, name: "Rime of the Ancient Mariner", artist: "Iron Maiden", album: "Powerslave", link: "", cover: "https://m.media-amazon.com/images/I/81qKQEXFRSL._UF1000,1000_QL80_.jpg")
    ]
    
    var body: some View {
        List {
            ForEach(songs.sorted(by: { return $0.name < $1.name }), id: \.id) { song in
                SongRowView(song: song).environmentObject(playlist)
            }
        }
        .padding(.top)
        .padding(.top)
    }
}

//#Preview {
//    SearchView()
//}
