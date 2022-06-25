//
//  BubbleView.swift
//  NewMap
//
//  Created by Maximilian Löhr on 11.04.22.
//

import SwiftUI
import MapKit

struct BubbleView: View {
    
    let playerCoordinate2D: CLLocationCoordinate2D
    let playerBearing: Double
    
    let bubbleLocation: CLLocationCoordinate2D
    let pixelsPerMeters: Double
    let sizePlaceholder: Double
    let colourPlaceholder: Color
   
    
    
    private var updatedAngle: Double {
        let playerBubbleBearing = playerBubbbleBearing(playerLocation: playerCoordinate2D, bubbleLocation: bubbleLocation)
        let updatedAngle = updatedAngle(playerAngle: playerBearing, bubbleAngle: playerBubbleBearing)
        
        return updatedAngle
    }
    
 
    private var distanceInPixels: Double {
        let distanceInMeters = distanceInMeters(playerLocation: playerCoordinate2D, bubbleLocation: bubbleLocation)
        return distanceInMeters * pixelsPerMeters
    }
    
    private var pixelPosition: (newX: Double, newY: Double) {
        let angleConverted = numberRadiensConverter(updatedAngle)
        
        let targetX = distanceInPixels * sin(angleConverted)
        let targetY = distanceInPixels * -cos(angleConverted) //NOTE: "-" for  inverting the y-Value
        
        let xRounded = targetX.rounded()
        let yRounded = targetY.rounded()
    
        return (newX: Double(xRounded), newY: Double(yRounded))
    }
    
 
    
    var body: some View {
        
        Circle()
            .fill(colourPlaceholder)
            .frame(width: CGFloat(pixelsPerMeters) * sizePlaceholder, height: CGFloat(pixelsPerMeters) * sizePlaceholder)
            .offset(x: pixelPosition.newX, y: pixelPosition.newY)
            .shadow(radius: 2)
          
        
        /*
        ZStack {
            Circle()
                .fill(.red)
                .frame(width: CGFloat(pixelsPerMeters) * sizePlaceholder, height: CGFloat(pixelsPerMeters) * 50)
                .offset(x: pixelPosition.newX, y: pixelPosition.newY)
            
            VStack {
                Text("newX: \(pixelPosition.newX), newY: \(pixelPosition.newY)")
                Text("playerBearing: \(playerBearing), pixelForMeters: \(pixelsPerMeters)")
                Text("distanceInPixels: \(distanceInPixels)")
            }
        }
        */
    }
    
}

extension BubbleView {
    
    static var calcTest: Double {
        return 21
    }
    
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
    
    
    
}

extension BubbleView {
    
    func numberRadiensConverter(_ number: Double) -> Double {
       return number * (.pi / 180.0)
    }
    
    func rad2deg(_ number: Double) -> Double {
           return number * 180 / .pi
    }
    
}


