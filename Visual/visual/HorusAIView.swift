import SwiftUI

struct HorusAIView: View {
    @Binding var rippleProgress: Double

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
                            .float(rippleProgress)
                            )
                    )
            }

            Image("horus-blue")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .allowsHitTesting(false)
                .padding(.bottom, 20)
        }
    }
}

