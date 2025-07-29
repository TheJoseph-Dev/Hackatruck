import SwiftUI

struct HorusAIView: View {
    @Binding var trigger: Bool
    @State private var animationStartTime: Date? = nil
    private let duration: TimeInterval = 1.0

    let start = Date();
    var body: some View {
        ZStack {
            TimelineView(.animation) { tl in
                let start = animationStartTime ?? tl.date
                let time = start.distance(to: tl.date);
                let progress = min(max(time / duration, 0), 1)
                Rectangle()
                    .colorEffect(
                        ShaderLibrary.horus(
                            .float2(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height),
                            .float(time),
                            .float(0.0)
                        )
                    )
            }

            Image("horus-blue")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .allowsHitTesting(false)
                .padding(.top, 20)
        }
        .onChange(of: trigger) { _ in
            animationStartTime = Date()
        }
    }
}

