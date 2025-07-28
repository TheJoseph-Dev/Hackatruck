import Foundation
import CoreLocation

class GPSAPI: NSObject, CLLocationManagerDelegate {
    let shared: GPSAPI = GPSAPI(refPoints: [])
    
    struct Point {
        let name: String
        var coordinate: CLLocationCoordinate2D
    }
    
    private var refPoints: [Point]
    private let locationManager = CLLocationManager()
    private var continuation: CheckedContinuation<(Point, CLLocationDistance)?, Error>?
    
    // Initialize with points
    init(refPoints: [Point]) {
        self.refPoints = refPoints
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // This function fetches the closest point asynchronously
    func getClosestPoint() async throws -> (Point, CLLocationDistance)? {
        // Request location permission
        locationManager.requestWhenInUseAuthorization()
        
        // Fetch the current location asynchronously
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            locationManager.requestLocation() // Request location
        }
    }
    
    // MARK: - CLLocationManagerDelegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first else {
            continuation?.resume(throwing: NSError(domain: "LocationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve location"]))
            return
        }

        let closestPoint = self.refPoints.min(by: {
            userLocation.distance(from: CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)) <
            userLocation.distance(from: CLLocation(latitude: $1.coordinate.latitude, longitude: $1.coordinate.longitude))
        })
        
        if let closestPoint = closestPoint {
            let distance = userLocation.distance(from: CLLocation(latitude: closestPoint.coordinate.latitude, longitude: closestPoint.coordinate.longitude))
            continuation?.resume(returning: (closestPoint, distance))
        } else {
            continuation?.resume(throwing: NSError(domain: "LocationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No points available"]))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.resume(throwing: error)
    }
}
