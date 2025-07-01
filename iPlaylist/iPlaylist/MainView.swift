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
                    ForEach(Array(playlist.songs), id: \.id) { song in
                        HStack {
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
                NavigationLink("Go to Another View", destination: AddSongView())
            }
        }
    }
}

