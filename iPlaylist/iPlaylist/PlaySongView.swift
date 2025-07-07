//
//  PlaySongView.swift
//  iPlaylist
//
//  Created by Turma01-23 on 19/06/25.
//

import SwiftUI

struct PlaySongView: View {
    
    @EnvironmentObject var playlist: Playlist;
    let song: Song;
    
    @State private var averageColor: UIColor = .clear
    let start = Date()
    
    var body: some View {
        ZStack {
            TimelineView(.animation) { timeline in
                let time = start.distance(to: timeline.date)
                
                Rectangle()
                    .ignoresSafeArea()
                    .colorEffect(ShaderLibrary.songBackground(
                        .float2(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height),
                        .float(time),
                        .float3(averageColor.simdRGB.x, averageColor.simdRGB.y, averageColor.simdRGB.z)
                    ))
            }
            
            VStack {
                AsyncImage(url: URL(string: song.cover)) { image in
                    image.resizable()
                        .onAppear {
                            Task {
                                await computeAverageColor(from: URL(string: song.cover)!)
                            }
                        }
                } placeholder: {
                    ProgressView().progressViewStyle(.circular)
                }
                .aspectRatio(contentMode: .fit)
                .padding()
                .padding()
                
                VStack {
                    Text(song.name)
                        .font(.title)
                        .bold()
                        .foregroundStyle(.white)
                    Text(song.artist)
                        .font(.subheadline)
                        .foregroundStyle(.white)
                }
                .shadow(color: .white, radius: 1)
                .shadow(color: .gray, radius: 2)
                
                LikeButton(song: song).environmentObject(playlist)
                    .padding()
                
                // Buttons
                HStack(spacing: 24) {
                    Button(action: {
                        
                    }) { Image(systemName: "shuffle").resizable().frame(width: 24, height: 24) }
                    Button(action: {
                        
                    }) { Image(systemName: "backward.end.fill").resizable().frame(width: 24, height: 24) }
                    Button(action: {
                        
                    }) { Image(systemName: "play.fill").resizable().frame(width: 24, height: 24) }
                    Button(action: {
                        
                    }) { Image(systemName: "forward.end.fill").resizable().frame(width: 24, height: 24) }
                    Button(action: {
                        
                    }) { Image(systemName: "repeat").resizable().frame(width: 24, height: 24) }
                }
                .foregroundStyle(.white)
                .padding(.top)
                
                Spacer()
            }
        }
        
    }
    
    func computeAverageColor(from url: URL) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data),
               let cgImage = uiImage.cgImage {
                let avgColor = getAverageColor(from: cgImage)
                await MainActor.run {
                    self.averageColor = avgColor
                }
            }
        } catch {
            print("Error loading image: \(error)")
        }
    }

    // Compute average color by downsampling
    func getAverageColor(from cgImage: CGImage, sampleSize: Int = 32) -> UIColor {
        let context = CGContext(
            data: nil,
            width: sampleSize,
            height: sampleSize,
            bitsPerComponent: 8,
            bytesPerRow: sampleSize * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )

        guard let context = context else { return .clear }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: sampleSize, height: sampleSize))

        guard let data = context.data else { return .clear }

        let pixelBuffer = data.bindMemory(to: UInt8.self, capacity: sampleSize * sampleSize * 4)
                
        let r = CGFloat(pixelBuffer[sampleSize*sampleSize+sampleSize])
        let g = CGFloat(pixelBuffer[sampleSize*sampleSize+sampleSize+1])
        let b = CGFloat(pixelBuffer[sampleSize*sampleSize+sampleSize+2])
        let a = CGFloat(pixelBuffer[sampleSize*sampleSize+sampleSize+3])
        let pixelCount = CGFloat(1)

        return UIColor(
            red: r / 255 / pixelCount,
            green: g / 255 / pixelCount,
            blue: b / 255 / pixelCount,
            alpha: a / 255 / pixelCount
        )
    }
}

//#Preview {
    //PlaySongView(song: Song(id: 4, name: "Rime of the Ancient Mariner", artist: "Iron Maiden", album: "Powerslave", link: "", cover: "https://m.media-amazon.com/images/I/81qKQEXFRSL._UF1000,1000_QL80_.jpg"))
//}

extension UIColor {
    var simdRGB: SIMD3<Float> {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return SIMD3(Float(r), Float(g), Float(b))
    }
}
