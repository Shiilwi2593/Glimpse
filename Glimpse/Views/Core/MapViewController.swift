// MapViewController.swift

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    private var mapView: MKMapView!
    private var locationManager: CLLocationManager!
    private let viewModel = MapViewModel()
    private var updateTimer: Timer?
    private var isInitialLocationSet = false
    
    private var userImage: UIImage?
    private var userName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        setupLocationManager()
        fetchUserInfo()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLogoutNotification), name: .didLogout, object: nil)
    }
    
    private func setupMap() {
        mapView = MKMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        view.addSubview(mapView)
        
        mapView.showsUserLocation = false // Hide the default blue dot
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            updateTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateLocationPeriodically), userInfo: nil, repeats: true)
        } else {
            print("Location services are not enabled")
        }
    }
    
    private func stopLocationUpdates() {
        updateTimer?.invalidate()
        updateTimer = nil
        locationManager.stopUpdatingLocation()
    }
    
    private func fetchUserInfo() {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("Token not found in UserDefaults")
            return
        }
        
        viewModel.getUserInfoByToken { [weak self] user in
            DispatchQueue.main.async {
                if let user = user {
                    self?.userName = user.username
                    if let urlString = user.image, let url = URL(string: urlString) {
                        self?.downloadImage(from: url)
                    }
                } else {
                    print("Failed to fetch user info.")
                }
            }
        }
    }
    
    private func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self?.userImage = UIImage(data: data)
                if let location = self?.locationManager.location {
                    self?.updateMapLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                }
            }
        }.resume()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        if !isInitialLocationSet {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            isInitialLocationSet = true
        }
        
        updateUserLocation(latitude: latitude, longitude: longitude)
        updateMapLocation(latitude: latitude, longitude: longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    // MARK: - Helper Methods
    
    private func updateUserLocation(latitude: Double, longitude: Double) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("Token not found")
            return
        }
        
        viewModel.updateLocation(token: token, latitude: latitude, longitude: longitude) { success, message in
            DispatchQueue.main.async {
                if success {
                    print("Location updated successfully")
                } else {
                    print("Failed to update location: \(message ?? "No message")")
                }
            }
        }
    }
    
    private func updateMapLocation(latitude: Double, longitude: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        // Remove existing annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // Add new annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = userName ?? "User"
        mapView.addAnnotation(annotation)
    }
    
    @objc private func updateLocationPeriodically() {
        if let location = locationManager.location {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            updateUserLocation(latitude: latitude, longitude: longitude)
            updateMapLocation(latitude: latitude, longitude: longitude)
        }
    }
    
    @objc private func handleLogoutNotification() {
        stopLocationUpdates()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .didLogout, object: nil)
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseID = "customAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKAnnotationView
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            
            // Create container view
            let containerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 60, height: 80)))
            containerView.tag = 100
            
            // Create and configure imageView
            let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 60, height: 60)))
            imageView.contentMode = .scaleAspectFill
            imageView.image = userImage ?? UIImage(named: "defaultavatar")
            imageView.layer.cornerRadius = 30
            imageView.clipsToBounds = true
            imageView.layer.borderWidth = 3
            imageView.layer.borderColor = UIColor.white.cgColor
            
            containerView.addSubview(imageView)
            
            // Create and configure label
            let label = UILabel(frame: CGRect(x: 0, y: 62, width: 60, height: 18))
            label.text = userName ?? "User"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
            containerView.addSubview(label)
            
            // Set containerView as the content of annotationView
            annotationView?.addSubview(containerView)
            annotationView?.frame.size = containerView.frame.size
            annotationView?.canShowCallout = false
            
        } else {
            annotationView?.annotation = annotation
            if let containerView = annotationView?.viewWithTag(100) {
                if let imageView = containerView.subviews.first as? UIImageView {
                    imageView.image = userImage ?? UIImage(named: "defaultavatar")
                }
                if let label = containerView.subviews.last as? UILabel {
                    label.text = userName ?? "User"
                }
            }
        }
        
        return annotationView
    }
}

extension Notification.Name {
    static let didLogout = Notification.Name("didLogout")
}
