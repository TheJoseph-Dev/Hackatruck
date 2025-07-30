// ContentView.swift

import SwiftUI

struct MainView: View {
    @EnvironmentObject var manager: ConfigurationManager

    @State private var showMenu = false
    @State private var showCamera = false
    @State private var showHelp = false;
    @State private var ripple = false
    @State private var rippleProgress: Double = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                showMenu.toggle()
                            }
                        }) {
                            Image(systemName: "line.3.horizontal").font(.title)
                        }
                        Text("HorusAI").font(.title2).fontWeight(.bold)
                        Spacer()
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape")
                        }
                    }
                    .padding()
                    .foregroundColor(.black)

                        ZStack {
                            HorusAIView(rippleProgress: $rippleProgress)
                                .onTapGesture {
                                    rippleProgress = 0
                                    withAnimation(.linear(duration: 1.5)) {
                                        rippleProgress = 1
                                    }
                                }
                                .onChange(of: rippleProgress) {
                                    if rippleProgress >= 1 {
                                        showCamera = true
                                        rippleProgress = 0;
                                    }
                                }
                            
                                .fullScreenCover(isPresented: $showCamera) {
                                    NavigationStack {
                                        CameraViewWrapper()
                                            .navigationTitle("LiveView")
                                            .navigationBarTitleDisplayMode(.inline)
                                            .environmentObject(manager)
                                    }
                                }

                        }

                }

                if showMenu {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation { showMenu = false }
                        }
                }


                HStack {
                    if showMenu {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Menu")
                                .font(.largeTitle).bold().padding(.top, 50)

                            Button("Histórico") { }
                            Button("Ajuda") {
                                showHelp = true
                            }
                            .navigationDestination(isPresented: $showHelp) {
                                AjudaView()
                            }

                            Spacer()

                            Divider()

                            HStack(spacing: 12) {
                                Image(systemName: "person.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.blue)

                                VStack(alignment: .leading) {
                                    Text(manager.currentConfig.nome
                                    )
                                        .font(.headline)
                                    Text("Perfil ativo")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .padding()
                        .frame(width: 250)
                        .background(Color.white)
                        .transition(.move(edge: .leading))
                        .offset(x: showMenu ? 0 : -250)
                        .animation(.easeInOut, value: showMenu)
                    }

                    Spacer()
                }
            }
            .onAppear {
                Task {
                    await manager.loadProfile()
                }
            }
        }

    }
}

#Preview {
    let manager = ConfigurationManager()
    
    return MainView()
        .environmentObject(manager)
}
