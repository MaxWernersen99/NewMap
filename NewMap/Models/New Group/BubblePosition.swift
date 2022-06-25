//
//  BubblePosition.swift
//  NewMap
//
//  Created by Maximilian Löhr on 11.04.22.
//

import Foundation
import SwiftUI
import MapKit


struct BubblePosition {
 
    private let playerCoordinate2D: CLLocationCoordinate2D
    private let  playerBearing: Double
    
    private let bubbleLocation: CLLocationCoordinate2D
    private let currentMapRect: MKMapRect
    
    //private var pixelForMeters: Double
    
    
    
    private var updatedAngle: Double {
        let playerBubbleBearing = playerBubbbleBearing(playerLocation: playerCoordinate2D, bubbleLocation: bubbleLocation)
        let updatedAngle = updatedAngle(playerAngle: playerBearing, bubbleAngle: playerBubbleBearing)
        
        return updatedAngle
    }
    
    
    private var distanceInPixels: Double {
        let distanceInMeters = distanceInMeters(playerLocation: playerCoordinate2D, bubbleLocation: bubbleLocation)
        return distanceInMeters * pixelForMeters
    }
    
    private var pixelForMeters: Double {
        let metersPerMapPointLAT = MKMetersPerMapPointAtLatitude(playerCoordinate2D.latitude)
        let metersPerPixel = metersPerMapPointLAT * currentMapRect.size.width / UIScreen.main.bounds.size.width
        print("NEW-PIXEL: \(metersPerPixel) #############")
        return Double(metersPerPixel)
    }
    
    
    var pixelPosition: (newX: Double, newY: Double) {
        let angleConverted = numberRadiensConverter(updatedAngle)
        
        let targetX = distanceInPixels * sin(angleConverted)
        let targetY = distanceInPixels * -cos(angleConverted) //NOTE: "-" for  inverting the y-Value
        
        let xRounded = targetX.rounded()
        let yRounded = targetY.rounded()
    
        return (newX: Double(xRounded), newY: Double(yRounded))
    }
    
    
    
    
    internal init(playerCoordinate2D: CLLocationCoordinate2D, playerBearing: Double, bubbleLocation: CLLocationCoordinate2D, currentMapRect: MKMapRect/*pixelForMeters: Double*/) {
        self.playerCoordinate2D = playerCoordinate2D
        self.playerBearing = playerBearing
        self.bubbleLocation = bubbleLocation
        self.currentMapRect = currentMapRect
        /*
        self.pixelForMeters = pixelForMeters
         */
    }
    
}

extension BubblePosition {
    
    func playerBubbbleBearing(playerLocation: CLLocationCoordinate2D, bubbleLocation: CLLocationCoordinate2D) -> Double {   //OK!
        let finalResult: Double
        
        let alphaL = bubbleLocation.longitude - playerLocation.longitude
        
        let x = cos(numberRadiensConverter(bubbleLocation.latitude)) * sin(numberRadiensConverter(alphaL))
        
        let y = (cos(numberRadiensConverter(playerLocation.latitude)) * sin(numberRadiensConverter(bubbleLocation.latitude))) - (sin(numberRadiensConverter(playerLocation.latitude)) * cos(numberRadiensConverter(bubbleLocation.latitude)) * cos(numberRadiensConverter(alphaL)))
        
        let inRadiens = atan2(x, y)
        let degreeConverter = rad2deg(inRadiens)
        
        if degreeConverter > 0 {
            finalResult = degreeConverter
       } else if degreeConverter < 0 {
           finalResult = 360.0 + degreeConverter
       } else {
           finalResult = degreeConverter
       }
        
        return finalResult
    }
    
  
    
    
    func updatedAngle(playerAngle: Double, bubbleAngle: Double) -> Double {
        let resultIn180 = (bubbleAngle - playerAngle).truncatingRemainder(dividingBy: 360)
          if resultIn180 < 0 {
              return(360 + resultIn180)
          } else {
              return resultIn180
          }
    }
    
    func distanceInMeters(playerLocation: CLLocationCoordinate2D, bubbleLocation: CLLocationCoordinate2D) -> CLLocationDistance{
        let point1 = MKMapPoint(playerLocation)
        let point2 = MKMapPoint(bubbleLocation)
        return point1.distance(to: point2)
        
    }
    
    /*
    func targetPoint(radius: Double, computedAngle: Double) -> (newX: Int, newY: Int) {   // NOTE: "radius" means distance in Pixelpoints here.   // OK!
        let angleConverted = numberRadiensConverter(computedAngle)
        
        let targetX = radius * sin(angleConverted)
        let targetY = radius * -cos(angleConverted) //NOTE: "-" for  inverting the y-Value
        
        let xRounded = targetX.rounded()
        let yRounded = targetY.rounded()
    
        return (newX: Int(xRounded), newY: Int(yRounded))
    }
    */
    
}

extension BubblePosition {
    
    func numberRadiensConverter(_ number: Double) -> Double {
       return number * (.pi / 180.0)
   }
    func rad2deg(_ number: Double) -> Double {
           return number * 180 / .pi
   }
    
}
