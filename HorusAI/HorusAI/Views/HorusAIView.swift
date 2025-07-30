import SwiftUI

struct HorusAIView: View {
    @Binding var rippleProgress: Double
    @State var discard: Float = 0
    let start = Date();
    var body: some View {
        ZStack {
            TimelineView(.animation) { tl in
                let time = start.distance(to: tl.date);
                Rectangle()
                    .colorEffect(
                        ShaderLibrary.horus(
                            .float2(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height),
                            .float(time),
                            .float(rippleProgress),
                            .float(discard)
                            )
                    )
            }
            
            VStack {
                if discard > 0.1 {
                    Spacer()
                }
                
                Image("horus-blue")
                    .resizable()
                    .scaledToFit()
                    .frame(width: discard > 0.1 ? 75 : 100, height: discard > 0.1 ? 75 : 100)
                    .allowsHitTesting(false)
                    .padding(.bottom, discard > 0.1 ? 50 : 20)
            }
        }
    }
}

