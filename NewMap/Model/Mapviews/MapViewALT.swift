//
//  MapViewAltTEST.swift
//  NewMap
//
//  Created by Maximilian Löhr on 27.04.22.
//

import SwiftUI
import MapKit
import GoogleMapsTileOverlay

struct MapViewALT: UIViewRepresentable {

    @EnvironmentObject var mapData: MapViewModel
    var bubbleDistanceValues: BubbleDistanceValues

    
        /*
        func makeCoordinator() -> MapViewCoordinator {
            return MapViewAlTEST.Coordinator()
        }
        */
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewALT.Coordinator(bubbleDistanceValues)
    }
        
        /**
         - Description - Replace the body with a make UIView(context:) method that creates and return an empty MKMapView
         */
        func makeUIView(context: Context) -> MKMapView {
            
            
            let view = mapData.mapViewALTERNATIVE
           // view.showsUserLocation = true
           // view.isRotateEnabled = true
            
            view.showsCompass = false
            view.isScrollEnabled = false
            view.isZoomEnabled = false
            view.isUserInteractionEnabled = false
            view.showsUserLocation = false
            /*
            let scale = MKScaleView(mapView: mapData.mapView)
            scale.scaleVisibility = .visible // always visible
            view.addSubview(scale)
            */
            view.subviews[1].isHidden = true        // dismisses legal-sign
            //test
            view.camera.centerCoordinateDistance = 0
            //
            
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
         //   print("ALTwidth: \(view.bounds.width), ALTheight: \(view.bounds.height)")
        }
    

    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        
        /*@ObservedObject*/ var bubbleDistanceValues: BubbleDistanceValues
        
        /*
        func changeHeight(_ mapView: MKMapView, currentDistance: Double) {
            let newHeight = currentDistance + bubbleDistanceValues.watchDIstanceDiffALT
            let userView = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude), fromDistance: newHeight, pitch: 0, heading: mapView.camera.heading)
            mapView.setCamera(userView, animated: true)
        }
        */
         
        init(_ bubbleDistanceValues: BubbleDistanceValues) {
              self.bubbleDistanceValues = bubbleDistanceValues
        }
        
     
       
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            
               if let tileOverlay = overlay as? MKTileOverlay {
                   return MKTileOverlayRenderer(tileOverlay: tileOverlay)
               }
               return MKOverlayRenderer(overlay: overlay)
        }
        
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            bubbleDistanceValues.distanceInMetersALT = mapView.camera.centerCoordinateDistance
            bubbleDistanceValues.diagonalScreenMetersALT = mapView.newBounds.firstBound.distance(from: mapView.newBounds.secondBound)
            bubbleDistanceValues.boundsALT = mapView.bounds.width   // 0,5 Pixel discreptancy to value in contentView
            
            //print("mapViewALT: \( mapView.camera.centerCoordinateDistance / (mapView.newBounds.firstBound.distance(from: mapView.newBounds.secondBound)))++++++")
    
            
            /*
            bubbleDistanceValues.mapviewALTboundsWidth = mapView.bounds.width
            bubbleDistanceValues.mapviewALTboundsHeight = mapView.bounds.height
           // print("mapViewALT: \((mapView.newBounds.firstBound.distance(from: mapView.newBounds.secondBound)) / mapView.camera.centerCoordinateDistance)++++++++")
            
            /*
            if bubbleDistanceValues.changeWatchDistanceALT == true {
                changeHeight(mapView, currentDistance: mapView.camera.centerCoordinateDistance)
                bubbleDistanceValues.changeWatchDistanceALT = false
                bubbleDistanceValues.watchDIstanceDiffALT = 0
            }
             */
            */
        }
        
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
           
        }
        
        func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
            //
        }
      
        
    }

}
