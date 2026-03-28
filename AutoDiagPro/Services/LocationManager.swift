import Foundation
import CoreLocation
import MapKit

// MARK: - Real-Time Location Manager
// Provides live GPS location updates for MapKit and other views
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var userHeading: Double = 0
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var locationError: String?
    @Published var isTracking = false
    @Published var speed: Double = 0 // m/s
    @Published var altitude: Double = 0 // meters
    @Published var accuracy: Double = 0 // meters
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 46.7712, longitude: 23.6236),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 5 // Update every 5 meters
        manager.activityType = .automotiveNavigation
        manager.allowsBackgroundLocationUpdates = false
        authorizationStatus = manager.authorizationStatus
    }
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func startTracking() {
        requestPermission()
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
        isTracking = true
        locationError = nil
    }
    
    func stopTracking() {
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
        isTracking = false
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.userLocation = location.coordinate
            self.speed = max(0, location.speed)
            self.altitude = location.altitude
            self.accuracy = location.horizontalAccuracy
            self.locationError = nil
            
            // Update region to follow user
            self.region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        DispatchQueue.main.async { [weak self] in
            self?.userHeading = newHeading.trueHeading
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            if let clError = error as? CLError {
                switch clError.code {
                case .denied:
                    self?.locationError = "Locatia este dezactivata. Activati din Setari > Confidentialitate > Servicii de localizare."
                case .locationUnknown:
                    self?.locationError = "Nu se poate determina locatia. Verificati semnalul GPS."
                default:
                    self?.locationError = "Eroare locatie: \(error.localizedDescription)"
                }
            }
            self?.isTracking = false
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async { [weak self] in
            self?.authorizationStatus = manager.authorizationStatus
            
            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                self?.startTracking()
            case .denied, .restricted:
                self?.locationError = "Accesul la locatie este refuzat. Activati din Setari."
                self?.isTracking = false
            default:
                break
            }
        }
    }
    
    // MARK: - Distance Calculation
    func distanceTo(_ coordinate: CLLocationCoordinate2D) -> Double? {
        guard let userLoc = userLocation else { return nil }
        let userCL = CLLocation(latitude: userLoc.latitude, longitude: userLoc.longitude)
        let targetCL = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return userCL.distance(from: targetCL) / 1000.0 // km
    }
}
