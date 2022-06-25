//
//  MapViewModel.swift
//  NewMap
//
//  Created by Maximilian Löhr on 30.03.22.
//

import MapKit
import SwiftUI
import CoreLocation
import Combine

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var mapView = MKMapView()
    @Published var mapViewALTERNATIVE = MKMapView()
    @Published var currentSpeed: Double = 0

    // test
    @Published var bootPhase = true
    @Published var currentDistanceMain: Double = 141.600889
    @Published var currentDistanceALT: Double = 32.726312
    
    var lastLocation: CLLocation?
    var degrees: Double = .zero 
    var userView: MKMapCamera!
    var userViewALTERNATIVE: MKMapCamera!
    var watchDistance: Double = 0 {
        willSet {
          //  watchDistance = 0
        }
        
        didSet {
            if watchDistance != 0 {
              //  adjustWatchdistance()
            }
            // getPixelSizeAdjustment()
        }
    }
    
/*
   var adjustedDistandeMain: Double {
        if currentDistanceMain == nil {
            return watchDistance
        } else {
            return currentDistanceMain! + watchDistance
        }
        
    }
    
    var adjustedDistandeALT: Double {
        if currentDistanceMain == nil {
            return watchDistance
        } else {
            return currentDistanceMain! + watchDistance
        }
    }
    */
    
    // TESTMETERS
    @Published var TESTHEIGHTREG = 0
    // ###
    
    // Alert...
    @Published var permissionDenied = false
    
    private let locationManager: CLLocationManager
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = -1     // kCLLocationAccuracyBestForNavigation
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        
       // self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.headingSetup()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3)  {
            self.bootPhase = false
        }
     
        
    }
    func adjustWatchdistanceTWO() {
        currentDistanceMain += 10
        currentDistanceALT += (0.7781871 * 10.0)  // 1.518
    }
    
    func adjustWatchdistance(higher: Bool) {
        
        
        if higher == true {
             currentDistanceMain = mapView.camera.centerCoordinateDistance + (mapView.camera.centerCoordinateDistance * 0.1)
             currentDistanceALT = mapViewALTERNATIVE.camera.centerCoordinateDistance + (mapViewALTERNATIVE.camera.centerCoordinateDistance * 0.1)
        } else {
             currentDistanceMain = mapView.camera.centerCoordinateDistance - (mapView.camera.centerCoordinateDistance * 0.1)
             currentDistanceALT = mapViewALTERNATIVE.camera.centerCoordinateDistance - (mapViewALTERNATIVE.camera.centerCoordinateDistance * 0.1)
        }
        
            if lastLocation != nil {
                self.userView = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: lastLocation!.coordinate.latitude, longitude: lastLocation!.coordinate.longitude), fromDistance: currentDistanceMain, pitch: 0, heading: degrees)
                mapView.setCamera(userView, animated: true)
              //  mapView.camera.centerCoordinateDistance = self.watchDistance
                // TEST ---------------------------
                self.userViewALTERNATIVE = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: lastLocation!.coordinate.latitude, longitude: lastLocation!.coordinate.longitude), fromDistance: currentDistanceALT, pitch: 0, heading: degrees)
                mapViewALTERNATIVE.setCamera(userViewALTERNATIVE, animated: true)
              //  mapViewALTERNATIVE.setCamera(userView, animated: true)
                
                
                //mapView.camera.centerCoordinateDistance = self.watchDistance
                // ###  ---------------------------
                watchDistance = 0
            }
    }
    
    /*
    func adjustWatchdistance(higher: Bool, meters: Double) {
        if higher == true {
            self.watchDistance += meters
            
            /*
            MKMapView.animate(withDuration: 0.5, animations: {
                self.mapView.camera.centerCoordinateDistance = self.watchDistance
                self.mapViewALTERNATIVE.camera.centerCoordinateDistance = self.watchDistance
            })
            */
            
            
            if lastLocation != nil {
                self.userView = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: lastLocation!.coordinate.latitude, longitude: lastLocation!.coordinate.longitude), fromDistance: self.watchDistance, pitch: 0, heading: degrees)
                mapView.setCamera(userView, animated: true)
                print("WATCHEDDISTANCE FIRED -------------------------------")
                // TEST ---------------------------
                self.userViewALTERNATIVE = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: lastLocation!.coordinate.latitude, longitude: lastLocation!.coordinate.longitude), fromDistance: self.watchDistance, pitch: 0, heading: degrees)
                mapViewALTERNATIVE.setCamera(userViewALTERNATIVE, animated: true)
                // ###  ---------------------------
              
            }
            
        } else {   // false = lower
            if self.watchDistance > 30 {
                self.watchDistance -= meters
                
                /*
                MKMapView.animate(withDuration: 0.5, animations: {
                    self.mapView.camera.centerCoordinateDistance = self.watchDistance
                    self.mapViewALTERNATIVE.camera.centerCoordinateDistance = self.watchDistance
                })
                */
                
                if lastLocation != nil {
                    self.userView = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: lastLocation!.coordinate.latitude, longitude: lastLocation!.coordinate.longitude), fromDistance: self.watchDistance, pitch: 0, heading: degrees)
                    mapView.setCamera(userView, animated: true)
                    
                    // TEST ---------------------------
                    self.userViewALTERNATIVE = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: lastLocation!.coordinate.latitude, longitude: lastLocation!.coordinate.longitude), fromDistance: self.watchDistance, pitch: 0, heading: degrees)
                       mapViewALTERNATIVE.setCamera(userViewALTERNATIVE, animated: true)
                    // ###  ---------------------------
                }
                
                
            }
        }
    }
    */
    
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Checking Permissions...
        
        switch manager.authorizationStatus {
        case .denied:
            // Alert...
            permissionDenied.toggle()
        case .notDetermined:
            // Requesting....
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            // If Permissin Given...
            manager.startUpdatingLocation()
            headingSetup()
        default:
            ()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Error....
        print(error.localizedDescription)
    }
    
    // Getting user Region....
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {return}
        
        currentSpeed = location.speed
        
        
        //self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 50, longitudinalMeters: 50)
        self.lastLocation = location
        self.userView = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: lastLocation!.coordinate.latitude, longitude: lastLocation!.coordinate.longitude), fromDistance: currentDistanceMain, pitch: 0, heading: degrees)
        mapView.setCamera(userView, animated: true)
        
        
        
        /*
        // Updating Map....
        //self.mapView.setRegion(self.region, animated: true)
     
        // Smooth Animations...
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
        */
        
        
        // TEST ---------------------------
           self.userViewALTERNATIVE = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: lastLocation!.coordinate.latitude, longitude: lastLocation!.coordinate.longitude), fromDistance: currentDistanceALT, pitch: 0, heading: degrees)
          mapViewALTERNATIVE.setCamera(userViewALTERNATIVE, animated: true)
        // ###  ---------------------------
        
    }
    
    // Heading
    
    private func headingSetup() {
        if CLLocationManager.headingAvailable() {
            self.locationManager.startUpdatingHeading()
        
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.degrees = newHeading.magneticHeading
        if lastLocation != nil {
            self.userView = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: lastLocation!.coordinate.latitude, longitude: lastLocation!.coordinate.longitude), fromDistance: currentDistanceMain, pitch: 0, heading: degrees)
            //mapView.setCamera(userView, animated: true)
            
            MKMapView.animate(withDuration: 0.5, animations: {
                self.mapView.camera.heading = self.degrees
            })
            mapView.setCamera(userView, animated: bootPhase ? false : true)
  
            /*
     
            mapView.camera.heading = self.degrees
            mapView.setCamera(userView, animated: true)
            */
         
            
            // ALT ---------------------------
            self.userViewALTERNATIVE = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: lastLocation!.coordinate.latitude, longitude: lastLocation!.coordinate.longitude), fromDistance: currentDistanceALT, pitch: 0, heading: degrees)
            MKMapView.animate(withDuration: 0.5, animations: {
                self.mapViewALTERNATIVE.camera.heading = self.degrees
            })
            mapViewALTERNATIVE.setCamera(userViewALTERNATIVE, animated: bootPhase ? false : true)
            //   ---------------------------
          
        }
    }
    
}


/*
 // TEST
 var objectWillChange = PassthroughSubject<Void, Never>()
 @Published var timerTestONE: Double = 0 {
     didSet {
        // objectWillChange.send()
     }
 }
 
 @Published var timerTestTWO: Double = 0 {
     didSet {
         //  objectWillChange.send()
     }
 }
 
 @Published var timerTestTHREE: Double = 0 {
     didSet {
         // objectWillChange.send()
     }
 }
 
 @Published var timerTestFOUR: Double = 0 {
     didSet {
         //  objectWillChange.send()
     }
 }
 
 var timerONE: Timer? {
      didSet {
          oldValue?.invalidate()
      }
  }
 func goTimerONE() {
     self.timerONE = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.fireTimerONE), userInfo: nil, repeats: true)
     }
 
 @objc func fireTimerONE() {
     print("FIRED: Timer1 // timerTestONE: \(timerTestONE)")
     timerTestONE += 1
 }
 
 var timerTWO: Timer? {
      didSet {
          oldValue?.invalidate()
      }
  }
 func goTimerTWO() {
     self.timerTWO = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.fireTimerTWO), userInfo: nil, repeats: true)
     }
 
 @objc func fireTimerTWO() {
     print("FIRED: Timer2 // timerTestTWO: \(timerTestTWO)")
     timerTestTWO += 1
 }
 
 var timerTHREE: Timer? {
      didSet {
          oldValue?.invalidate()
      }
  }
 func goTimerTHREE() {
     self.timerTHREE = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(self.fireTimerTHREE), userInfo: nil, repeats: true)
     }
 
 @objc func fireTimerTHREE() {
     print("FIRED: Timer3 // timerTestTHREE: \(timerTestTHREE)")
     timerTestTHREE += 1
 }
 
 var timerFOUR: Timer? {
      didSet {
          oldValue?.invalidate()
      }
  }
 func goTimerFOUR() {
     self.timerFOUR = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.fireTimerFOUR), userInfo: nil, repeats: true)
     }
 
 @objc func fireTimerFOUR() {
     print("FIRED: Timer4 // timerTestFOUR: \(timerTestFOUR)")
     timerTestFOUR += 1
 }
 // ------------------
 func startTestTimers() {
     goTimerONE()
     goTimerTWO()
     goTimerTHREE()
     goTimerFOUR()
 }
 
 func stopTestTimers() {
     timerONE?.invalidate()
     timerTWO?.invalidate()
     timerTHREE?.invalidate()
     timerFOUR?.invalidate()
 }

 
 // ###
 
 
 
 */
