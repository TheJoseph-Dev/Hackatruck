struct HorusAIView: View {
    @Binding var rippleProgress: Double = 0

    let start = Date();
    var body: some View {
        ZStack {
            TimelineView(.animation) { tl in
                let time = start.distance(to: tl.date);
                Rectangle()
                    .colorEffect(
                        ShaderLibrary.horus("HorusAIShader")
                            .float2(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
                            .float(time)
                            .float(rippleProgress)
                    )
            }

            Image("horusAILogo")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .allowsHitTesting(false)
        }
    }
}