//
//  BubbleDistanceValues.swift
//  NewMap
//
//  Created by Maximilian Löhr on 29.05.22.
//

import Foundation
import SwiftUI
import MapKit

class BubbleDistanceValues: ObservableObject {

    
    
    @Published var distanceInMetersMAIN: Double = 0
    @Published var distanceInMetersALT: Double = 0
    
    @Published var userLocationUpdated: CLLocationCoordinate2D?
    @Published var userHeadingUpdated: Double = 0
    
    @Published var pixelsPerMetersMAIN: Double = 0
    @Published var pixelsPerMetersALT: Double = 0
    
    //PixelPerMeterCalc
    let diagonalScreenPixelsMAIN: Double
    var diagonalScreenPixelsALT: Double {
        let diagonaleBoundALT = boundsALT * sqrt(2)
        return diagonaleBoundALT
    }
    init() {
        let diagonaleBoundsMAIN = (UIScreen.main.bounds.width * UIScreen.main.bounds.width) + (UIScreen.main.bounds.height * UIScreen.main.bounds.height)
        diagonalScreenPixelsMAIN = sqrt(diagonaleBoundsMAIN)
    }
    var boundsALT: Double = 0 {
        didSet {
          //  print("boundsALT: \(boundsALT)")
        }
    }
    
    var diagonalScreenMetersMAIN: Double = 0 {
        didSet {
            pixelsPerMetersMAIN = diagonalScreenPixelsMAIN / diagonalScreenMetersMAIN
        }
    }
    
    var diagonalScreenMetersALT: Double = 0 {
        didSet {
            pixelsPerMetersALT = diagonalScreenPixelsALT / diagonalScreenMetersALT
        }
    }
    
 
    
    // ---
    
    // RelationCalc
    
    
    var groundMPerDistanceMMain: Double {
        let meterValue = distanceInMetersMAIN / diagonalScreenMetersMAIN
        print("meterValueMAIN: \(meterValue)")
        return meterValue
    }
    
    var groundMPerDistanceMALT: Double {
        let meterValue = distanceInMetersALT / diagonalScreenMetersALT
        print("meterValueALT: \(meterValue)")
        return meterValue
    }
  
    
   

   

    
    
 
    
    var currentSpeed: Double = 0 {
        didSet {
        //    print("speedValue: \(currentSpeed)")
        }
    }
    
    /*
    
     // TEST
     var higher = true
     var watchDistance: Double = 0
     
     
     
     @Published var pixelsPerMetersALT: Double = 0
     var pixelRatio: Double {
         return diagonalScreenPixelsALT / diagonalScreenPixels
     }
     
     
    
     
     /*
     var diagonalScreenPixels: Double {
         let digonalSquare = (UIScreen.main.bounds.width * UIScreen.main.bounds.width) + (UIScreen.main.bounds.height * UIScreen.main.bounds.height)
         return sqrt(digonalSquare)
     }
     */
     // ---
    // TESTNEW
    var changeWatchDistanceMAIN = false
    var watchDIstanceDiffMAIN: Double = 0
    var changeWatchDistanceALT = false
    var watchDIstanceDiffALT: Double = 0
    // ###
    
    
    */

}
