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
                .onChange(of: triggerRipple) { _ in
                    isNavigated = true
                }
                .onAppear {
                    let points = [
                        GPSAPI.Point(name: "Unoeste Campus I", coordinate: CLLocationCoordinate2D(latitude: -22.132934541190558, longitude: -51.40283834860905)),
                        GPSAPI.Point(name: "Unoeste Campus II", coordinate: CLLocationCoordinate2D(latitude: -22.11570377732075, longitude: -51.44804969705185)),
                        GPSAPI.Point(name: "Atacadao", coordinate: CLLocationCoordinate2D(latitude: -22.120689048428627, longitude: -51.439377154314336))
                    ]
                    let api = GPSAPI(refPoints: points)
                    
                    Task {
                        do {
                            let a = try await api.getClosestPoint()
                            print(a?.0.name ?? "None")
                        }
                        catch {
                            print("Error")
                        }
                    }
                }
        }
    }
}

#Preview {
    NavigationStack() {
        PseudoContentView()
        
        
    }
}
