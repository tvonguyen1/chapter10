//
//  LocationDemoViewController.swift
//  chapter10
//
//  Created by user217022 on 4/24/22.
//

import UIKit
import CoreLocation

class LocationDemoViewController: UIViewController,  CLLocationManagerDelegate {

    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var lblLongitude: UILabel!
    @IBOutlet weak var lblLocationAccuracy: UILabel!
    @IBOutlet weak var lblHeadingAccuracy: UILabel!
    @IBOutlet weak var lblAltitude: UILabel!
    @IBOutlet weak var addressToCoordinates: UIButton!
    @IBOutlet weak var lblAltitudeAccuracy: UILabel!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var lblHeading: UILabel!
    
    //"lazy" indicates that while the line indicates that the CLGeoCoder object should be created immediately, instantiation will be deferred until the object is actually needed. This is called "lazy instantiation" and allows the system to conserve resources.
    lazy var geoCoder = CLGeocoder()
    var locationManager: CLLocationManager!

        @objc func dismissKeyboard() {
            //Causes the view (or one of its embedded text fields) to resign the first responder status.
            view.endEditing(true)
        }
    override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(self.dismissKeyboard))
            view.addGestureRecognizer(tap)
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization() //ask for permission to use location
        }
        
        func locationManager(_ manager: CLLocationManager,
                             didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse {
                print("Permission granted")
            }
            else {
                print("Permission NOT granted")
            }
        }
    
    @IBAction func addressToCoordinates(_ sender: Any) {
            let address = "\(txtStreet.text!), \(txtCity.text!), \(txtState.text!))"
            geoCoder.geocodeAddressString(address) {(placemarks, error) in
                self.processAddressResponse(withPlacemarks: placemarks, error: error)
            }
        }
    
        
        private func processAddressResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
            if let error = error {
                print("Geocode Error: \(error)")
            }
            else {
                var bestMatch: CLLocation?
                if let placemarks = placemarks, placemarks.count > 0 {
                    bestMatch = placemarks.first?.location
                }
                if let coordinate = bestMatch?.coordinate {
                    lblLatitude.text = String(format: "%g\u{00B0}", coordinate.latitude)
                    lblLongitude.text = String(format: "%g\u{00B0}", coordinate.longitude)
                }
                else {
                    print("Didn't find any matching locations")
                }
            }
        }
    
    @IBAction func deviceCoordinates(_ sender: Any) {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.distanceFilter = 100
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
        
        override func viewDidDisappear(_ animated: Bool) {
            locationManager.stopUpdatingLocation()
            locationManager.stopUpdatingHeading()
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                let eventDate = location.timestamp
                let howRecent = eventDate.timeIntervalSinceNow
                if Double(howRecent) < 15.0 {
                    let coordinate = location.coordinate
                    lblLongitude.text = String(format: "%g\u{00B0}", coordinate.longitude)
                    lblLatitude.text = String(format: "%g\u{00B0}", coordinate.latitude)
                    lblLocationAccuracy.text = String(format: "%gm", location.horizontalAccuracy)
                    lblAltitude.text = String(format: "%gm", location.altitude)
                    lblAltitudeAccuracy.text = String(format: "%gm", location.verticalAccuracy)
                }
            }
        }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
            if newHeading.headingAccuracy > 0 {
                let theHeading = newHeading.trueHeading
                var direction: String
                switch theHeading {
                case 225..<315:
                    direction = "W"
                case 135..<225:
                    direction = "S"
                case 45..<135:
                    direction = "E"
                default:
                    direction = "N"
                }
                lblHeading.text = String(format: "%g\u{00B0} (%@)", theHeading, direction)
                lblHeadingAccuracy.text = String(format: "%g\u{00B0}", newHeading.headingAccuracy)
            }
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            let errorType = error._code == CLError.denied.rawValue ? "Location Permission Denied" :
            "Unknown Error"
            let alertController = UIAlertController(title: "Error Getting Location: \(errorType)",
                message: "Error Message: \(error.localizedDescription))",
                preferredStyle: .alert)
            let actionOK = UIAlertAction(title: "OK",
                                         style: .default,
                                         handler: nil)
            
            alertController.addAction(actionOK)
            present(alertController, animated: true, completion: nil)
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
