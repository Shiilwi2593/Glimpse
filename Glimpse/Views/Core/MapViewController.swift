// MapViewController.swift

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // MARK: - Variables
    private var mapView: MKMapView!
    private var locationManager: CLLocationManager!
    private let mapVM = MapViewModel()
    private var updateTimer: Timer?
    private var isInitialLocationSet = false
    
    private var userImage: UIImage?
    private var userName: String?
    
    private var userAnnotation: MKPointAnnotation?
    private var friendAnnotations: [MKPointAnnotation] = []
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        fetchUserInfo()
        setupLocationManager()
        setupNotificationObserver()
        
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.fetchAndUpdateFriendsLocations()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .didLogout, object: nil)
    }
    
    
    // MARK: - Setup
    private func setupMap() {
        mapView = MKMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        mapView.showsUserLocation = false
        view.addSubview(mapView)
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            updateTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(updateLocationPeriodically), userInfo: nil, repeats: true)
        } else {
            print("Location services are not enabled")
        }
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleLogoutNotification), name: .didLogout, object: nil)
    }
    
    // MARK: - Helper Methods
    private func fetchUserInfo() {
        mapVM.getUserInfoByToken { [weak self] user in
            DispatchQueue.main.async {
                if let user = user {
                    self?.userName = user.username
                    print("Fetched username: \(self?.userName ?? "No username")")
                    if let urlString = user.image, let url = URL(string: urlString) {
                        self?.downloadImage(from: url)
                    }
                    // Update the user annotation after fetching user info
                    self?.updateUserAnnotation()
                } else {
                    print("Failed to fetch user info.")
                }
            }
        }
    }
    
    private func updateUserAnnotation() {
        if let userAnnotation = userAnnotation {
            userAnnotation.title = userName
            // Xóa annotation cũ
            mapView.removeAnnotation(userAnnotation)
        } else {
            userAnnotation = MKPointAnnotation()
            userAnnotation?.title = userName ?? "User"
        }
        // Thêm annotation mới
        mapView.addAnnotation(userAnnotation!)
    }
    
    private func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self?.userImage = UIImage(data: data)
                if let location = self?.locationManager.location {
                    self?.updateMapLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                }
            }
        }.resume()
    }
    
    // MARK: - Location Management
    private func updateUserLocation(latitude: Double, longitude: Double) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("Token not found")
            return
        }
        
        mapVM.updateLocation(token: token, latitude: latitude, longitude: longitude) { success, message in
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
        
        if userAnnotation == nil {
            userAnnotation = MKPointAnnotation()
            userAnnotation?.title = userName ?? "User"
            mapView.addAnnotation(userAnnotation!)
        }
        
        userAnnotation?.coordinate = coordinate
        
        // Update the annotation view
        if let annotationView = mapView.view(for: userAnnotation!) {
            updateAnnotationView(annotationView)
        }
    }
    
    
    @objc private func updateLocationPeriodically() {
        if let location = locationManager.location {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            updateUserLocation(latitude: latitude, longitude: longitude)
            updateMapLocation(latitude: latitude, longitude: longitude)
        }
    }
    
    private func stopLocationUpdates() {
        updateTimer?.invalidate()
        updateTimer = nil
        locationManager.stopUpdatingLocation()
    }
    // MARK: - Friends Location
    private func fetchAndUpdateFriendsLocations() {
        mapVM.fetchFriendsLocation { [weak self] friends in
            DispatchQueue.main.async {
                self?.updateFriendsAnnotations(friends)
            }
        }
    }
    
    private func updateFriendsAnnotations(_ friends: [[String: Any]]?) {
        // Remove only friend annotations, not the user annotation
        mapView.removeAnnotations(friendAnnotations)
        friendAnnotations.removeAll()
        
        guard let friends = friends else { return }
        
        for friend in friends {
            if let latitude = friend["latitude"] as? Double,
               let longitude = friend["longitude"] as? Double,
               let username = friend["username"] as? String {
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                
                // Check if this friend's location is not the same as the user's location
                if userAnnotation?.coordinate.latitude != latitude || userAnnotation?.coordinate.longitude != longitude {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = username
                    friendAnnotations.append(annotation)
                }
            }
            
        }
   
        
        mapView.addAnnotations(friendAnnotations)
    }
    
    // MARK: - Notification Handlers
    @objc private func handleLogoutNotification() {
        stopLocationUpdates()
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
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseID = annotation === userAnnotation ? "userAnnotation" : "friendAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        if annotation === userAnnotation {
            configureUserAnnotation(annotationView)
        } else {
            configureFriendAnnotation(annotationView)
        }
        
        return annotationView
    }
    
    private func configureUserAnnotation(_ annotationView: MKAnnotationView?) {
        let containerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 60, height: 80)))
        containerView.tag = 100
        
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 60, height: 60)))
        imageView.contentMode = .scaleAspectFill
        imageView.image = userImage ?? UIImage(named: "defaultavatar")
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor(hex: "43D53E").cgColor
        containerView.addSubview(imageView)
        
        let label = UILabel(frame: CGRect(x: 0, y: 62, width: 60, height: 18))
        label.text = userName ?? "User"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        containerView.addSubview(label)
        
        annotationView?.addSubview(containerView)
        annotationView?.frame.size = containerView.frame.size
        
    }
    
    private func configureFriendAnnotation(_ annotationView: MKAnnotationView?) {
        var containerView = annotationView?.viewWithTag(100) as? UIView
        if containerView == nil {
            // Only create the container view if it doesn't already exist
            containerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 60, height: 80)))
            containerView!.tag = 100
            
            let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 60, height: 60)))
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 30
            imageView.clipsToBounds = true
            imageView.layer.borderWidth = 2
            imageView.layer.borderColor = UIColor(hex: "4a7eba").cgColor
            containerView!.addSubview(imageView)
            
            let label = UILabel(frame: CGRect(x: 0, y: 62, width: 60, height: 18))
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
            containerView!.addSubview(label)
            
            annotationView?.addSubview(containerView!)
            annotationView?.frame.size = containerView!.frame.size
        }
        
        // Update existing image and label without creating new views
        if let imageView = containerView?.subviews.first as? UIImageView {
            imageView.image = UIImage(named: "defaultavatar") // Update this to the actual friend's image if available
        }
        
        if let label = containerView?.subviews.last as? UILabel {
            label.text = annotationView?.annotation?.title ?? "Friend"
        }

        // Optionally, only animate the first time or under certain conditions
        if shouldAnimate(annotationView: annotationView) {
            animateAnnotationView(containerView!)
        }
    }

    private func shouldAnimate(annotationView: MKAnnotationView?) -> Bool {
        return true // Or use a condition to limit when animation happens
    }
    
    
    private func updateAnnotationView(_ annotationView: MKAnnotationView?) {
        if let containerView = annotationView?.viewWithTag(100) {
            if let imageView = containerView.subviews.first as? UIImageView {
                imageView.image = userImage ?? UIImage(named: "defaultavatar")
                animateAnnotationView(imageView)
            }
            if let label = containerView.subviews.last as? UILabel {
                label.text = userName ?? "User"
            }
            
        }
        
    }
    
    private func animateAnnotationView(_ containerView: UIView) {
        containerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        // Animation for scaling the container view (image + label)
        UIView.animate(withDuration: 0.3, animations: {
            containerView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) // Scale up
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                containerView.transform = CGAffineTransform.identity // Scale back to original size
            }
        }
        
    }
    
}

extension Notification.Name {
    static let didLogout = Notification.Name("didLogout")
}
