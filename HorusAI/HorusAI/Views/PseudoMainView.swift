/*
import SwiftUI
import CoreLocation
struct PseudoContentView: View {
    @State private var triggerRipple = false
    @State private var isNavigated = false

    var body: some View {
        ZStack {
            HorusAIView(trigger: $triggerRipple)
                .onTapGesture {
                    triggerRipple.toggle()  // Just flips to trigger
                }
                .onChange(of: triggerRipple) {
                    isNavigated = true
                }
                .onAppear {
                    /*
                    Task {
                        do {
                            let a = try await GPSAPI.shared.getClosestPoint()
                            print(a?.0.name ?? "None")
                        }
                        catch {
                            print("Error")
                        }
                    }
                     */
                }
        }
    }
}

#Preview {
    NavigationStack() {
        PseudoContentView()
        
        
    }
}
*/
