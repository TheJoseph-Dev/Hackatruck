struct PseudoContentView: View {
    @State private var rippleProgress: Double = 0
    @State private var isNavigated = false

    var body: some View {
        ZStack {
            HorusAIView(rippleProgress: $rippleProgress)
            .onTapGesture {
                rippleProgress = 0
                withAnimation(.linear(duration: 1.5)) {
                    rippleProgress = 1
                }
            }
            .onChange(of: rippleProgress) { newValue in
                if newValue >= 1 {
                    isNavigated = true
                }
            }

            NavigationLink(destination: NextView(), isActive: $isNavigated) {
                CameraViewWrapper()
            }
        }
    }
}
