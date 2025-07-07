//
//  PlaylistView.swift
//  iPlaylist
//
//  Created by Turma01-23 on 16/06/25.
//

import SwiftUI

struct PlaylistView: View {
    @EnvironmentObject var playlist: Playlist;
    @State private var showStats: Bool = false;
    var body: some View {
        
        VStack {
            List {
                ForEach(Array(playlist.songs).sorted(by: { return $0.name < $1.name }), id: \.id) { song in
                    SongRowView(song: song).environmentObject(playlist)
                }
            }
            .padding(.top)
            .padding(.top)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showStats = true;
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }
            .sheet(isPresented: $showStats) {
                PlaylistStatusView()
                    .environmentObject(playlist)
                    .preferredColorScheme(.dark)
            }
            
            //Navigation to another view
            //NavigationLink("Add Song", destination: AddSongView().environmentObject(playlist))
            //    .padding()
        }
    }
}
