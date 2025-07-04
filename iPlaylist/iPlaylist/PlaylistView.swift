//
//  PlaylistView.swift
//  iPlaylist
//
//  Created by Turma01-23 on 16/06/25.
//

import SwiftUI

struct PlaylistView: View {
    @EnvironmentObject var playlist: Playlist;
    @State var showStats: Bool = false;
    var body: some View {
        
        VStack {
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
