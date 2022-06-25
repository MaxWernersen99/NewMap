//
//  MapView.swift
//  NewMap
//
//  Created by Maximilian Löhr on 30.03.22.
//

import SwiftUI
import MapKit
import GoogleMapsTileOverlay




struct MapViewMAIN: UIViewRepresentable {

    @EnvironmentObject var mapData: MapViewModel
    var bubbleDistanceValues: BubbleDistanceValues
   // @EnvironmentObject var bubbleDistanceValues: BubbleDistanceValues
    

        func makeCoordinator() -> MapViewCoordinator {
            return MapViewMAIN.Coordinator(bubbleDistanceValues)
        }
        
        /**
         - Description - Replace the body with a make UIView(context:) method that creates and return an empty MKMapView
         */
        func makeUIView(context: Context) -> MKMapView {
            
            
            let view = mapData.mapView
           // view.showsUserLocation = true
           // view.isRotateEnabled = true
            
            view.showsCompass = false
            view.isScrollEnabled = false
            view.isZoomEnabled = false
            view.showsUserLocation = false
            view.isUserInteractionEnabled = false
            /*
            let scale = MKScaleView(mapView: mapData.mapView)
            scale.scaleVisibility = .visible // always visible
            view.addSubview(scale)
            */
            view.camera.centerCoordinateDistance = 0
            view.delegate = context.coordinator
           
           
         
                if let jsonURL = Bundle.main.url(forResource: "CustomMap", withExtension: "json") {
                    let tileOverlay = try? GoogleMapsTileOverlay(jsonURL: jsonURL)
                    tileOverlay!.canReplaceMapContent = true
                    view.addOverlay(tileOverlay!, level: .aboveLabels)
                } else {
                    print("Unable to find style.json")
                }
            
         
            
            return view
        }
        
      
        
        func updateUIView(_ view: MKMapView, context: Context){
            //print("VIEW UPDATED")
        }
    

    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        
        
        /*@ObservedObject*/ var bubbleDistanceValues: BubbleDistanceValues
        
       
      /*
        func changeHeight(_ mapView: MKMapView, currentDistance: Double) {
            let newHeight = currentDistance + bubbleDistanceValues.watchDIstanceDiffMAIN
            let userView = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude), fromDistance: newHeight, pitch: 0, heading: mapView.camera.heading)
            mapView.setCamera(userView, animated: true)
        }
        */
     
         
        init(_ bubbleDistanceValues: BubbleDistanceValues) {
              self.bubbleDistanceValues = bubbleDistanceValues
        }
       
        
        /*
        var mapViewController: MapView
        init(_ control: MapView) {
              self.mapViewController = control
        }
        */

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
               if let tileOverlay = overlay as? MKTileOverlay {
                   return MKTileOverlayRenderer(tileOverlay: tileOverlay)
               }
               return MKOverlayRenderer(overlay: overlay)
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            
            bubbleDistanceValues.userLocationUpdated = mapView.centerCoordinate
            bubbleDistanceValues.userHeadingUpdated = mapView.camera.heading
            
            
            bubbleDistanceValues.diagonalScreenMetersMAIN = mapView.newBounds.firstBound.distance(from: mapView.newBounds.secondBound)
            bubbleDistanceValues.distanceInMetersMAIN = mapView.camera.centerCoordinateDistance
        
            //print("mapViewMAIN: \( mapView.camera.centerCoordinateDistance / (mapView.newBounds.firstBound.distance(from: mapView.newBounds.secondBound)))------")
            
            /*
           // print(bubbleDistanceValues.changeWatchDistanceMAIN.description)
            // print("mapViewMAIN: \((mapView.newBounds.firstBound.distance(from: mapView.newBounds.secondBound)) / mapView.camera.centerCoordinateDistance)------------")
           

            /*
            if bubbleDistanceValues.changeWatchDistanceMAIN == true {
                changeHeight(mapView, currentDistance: mapView.camera.centerCoordinateDistance)
                bubbleDistanceValues.changeWatchDistanceMAIN = false
                bubbleDistanceValues.watchDIstanceDiffMAIN = 0
            }
            */
            
          //  print("REGcenterCoordinateDistance: \(mapView.camera.centerCoordinateDistance) ---")
          //  print("TEST---------------: \(bubbleDistanceValues.pixelRatio)-----")
           */
            
            
        }
        
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
           // print("userLoC: \(userLocation.coordinate.latitude)")
            //print userLocation.location?.speed
        }
        
         func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if view.annotation is MKUserLocation {
                mapView.deselectAnnotation(view.annotation, animated: false)
                return
            }

            // all other didSelect annotation logic
        }
        
        /*
            func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
          
                   mapView.camera.centerCoordinateDistance =  bubbleDistanceValues.watchDistance
               
            }
        */
        
        
        }
        
      
      
        
    }





public extension MKMapView {
    
    func changeMapviewDistance(mapview: MKMapView) {
        
    }

 static var userSpeed: Double = 0
    
  var newBounds: MapBounds {
    let originPoint = CGPoint(x: bounds.origin.x + bounds.size.width, y: bounds.origin.y)
    let rightBottomPoint = CGPoint(x: bounds.origin.x, y: bounds.origin.y + bounds.size.height)

    let originCoordinates = convert(originPoint, toCoordinateFrom: self)
    let rightBottomCoordinates = convert(rightBottomPoint, toCoordinateFrom: self)

    return MapBounds(
      firstBound: CLLocation(latitude: originCoordinates.latitude, longitude: originCoordinates.longitude),
      secondBound: CLLocation(latitude: rightBottomCoordinates.latitude, longitude: rightBottomCoordinates.longitude)
    )
  }
}

public struct MapBounds {
  let firstBound: CLLocation
  let secondBound: CLLocation
}


/*
 // TEST

 @Published var timerTestONE: Double = 0
 
 @Published var timerTestTWO: Double = 0
 
 @Published var timerTestThree: Double = 0
 
 @Published var timerTestFOUR: Double = 0
 // ###
 
 func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
 // NEW
 /*
 let mapRectNEW = mapView.visibleMapRect
 let mpTopLeft: MKMapPoint = mapView.visibleMapRect.origin;

 let mpTopRight: MKMapPoint = MKMapPoint(x: mapView.visibleMapRect.origin.x + mapView.visibleMapRect.size.width, y: mapView.visibleMapRect.origin.y)
 

 let mpBottomRight: MKMapPoint = MKMapPoint(x: mapView.visibleMapRect.origin.x + mapView.visibleMapRect.size.width, y: mapView.visibleMapRect.origin.y + mapView.visibleMapRect.size.height)


 let horitontalDistance: CLLocationDistance = mpTopLeft.distance(to: mpTopRight);
 let verticalDistance: CLLocationDistance = mpTopRight.distance(to: mpBottomRight);
 let metersPerPixelNEW = horitontalDistance / UIScreen.main.bounds.size.width
 // ###
 
 // OLD
 let mapRectOLD = mapView.visibleMapRect
 let metersPerMapPointLAT = MKMetersPerMapPointAtLatitude(mapView.userLocation.coordinate.latitude)
 let metersPerPixelOLD1 = (metersPerMapPointLAT * mapRectOLD.size.width) / mapView.bounds.size.width
 let metersPerPixelOLD2 = (metersPerMapPointLAT * mapRectOLD.size.width) / UIScreen.main.bounds.size.width
 */
 
 }
 
 */
