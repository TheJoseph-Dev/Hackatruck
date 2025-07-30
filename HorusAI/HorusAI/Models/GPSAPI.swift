import CoreLocation

class GPSAPI: NSObject, CLLocationManagerDelegate {
    static let points = [
        GPSAPI.Point(name: "Universidade do Oeste Paulista - Unoeste Campus 1", coordinate: CLLocationCoordinate2D(latitude: -22.132934541190558, longitude: -51.40283834860905)),
        GPSAPI.Point(name: "Universidade do Oeste Paulista - Unoeste Campus 2", coordinate: CLLocationCoordinate2D(latitude: -22.11570377732075, longitude: -51.44804969705185)),
        GPSAPI.Point(name: "Mercado Atacadao", coordinate: CLLocationCoordinate2D(latitude: -22.120689048428627, longitude: -51.439377154314336))
    ]
    
    struct QueryData {
        let point: Point
        let distance: Double
        let location: CLLocation
    }
    
    static let shared: GPSAPI = GPSAPI(refPoints: GPSAPI.points)
    
    struct Point {
        let name: String
        var coordinate: CLLocationCoordinate2D
    }
    
    private var refPoints: [Point]
    private let locationManager = CLLocationManager()
    private var continuation: CheckedContinuation<QueryData?, Error>?
    
    init(refPoints: [Point]) {
        self.refPoints = refPoints
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func getClosestPoint() async throws -> QueryData? {
        locationManager.requestWhenInUseAuthorization()
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            locationManager.requestLocation()
        }
    }
    
    // MARK: - CLLocationManagerDelegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first else {
            continuation?.resume(throwing: NSError(domain: "LocationError", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "Unable to retrieve location"
            ]))
            return
        }

        let closestPoint = self.refPoints.min(by: {
            userLocation.distance(from: CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)) <
            userLocation.distance(from: CLLocation(latitude: $1.coordinate.latitude, longitude: $1.coordinate.longitude))
        })
        
        if let closestPoint = closestPoint {
            let distance = userLocation.distance(from: CLLocation(latitude: closestPoint.coordinate.latitude, longitude: closestPoint.coordinate.longitude))
            continuation?.resume(returning: QueryData(point: closestPoint, distance: distance.magnitude, location: userLocation))
        } else {
            continuation?.resume(throwing: NSError(domain: "LocationError", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "No points available"
            ]))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.resume(throwing: error)
    }
}
