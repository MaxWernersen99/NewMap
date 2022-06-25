//
//  ContentView.swift
//  NewMap
//
//  Created by Maximilian Löhr on 30.03.22.
//

import SwiftUI
import MapKit

struct ContentView: View {
   @StateObject var mapData = MapViewModel()
   @StateObject var bubbleDistanceValues = BubbleDistanceValues()
    
   // BuildingCircleSize
    @State var circleValue: CGFloat = UIScreen.main.bounds.width / 2
    
    var mainSpace: Double {
        return UIScreen.main.bounds.height * UIScreen.main.bounds.width
    }
    
    var altSpace: Double {
        return (circleValue) * (circleValue)
    }
    
    var spaceRatio: Double {
        return altSpace / mainSpace
    }
    
    
    // ###
    
    var body: some View {
        
        ZStack {
            MapViewMAIN(bubbleDistanceValues: bubbleDistanceValues).edgesIgnoringSafeArea(.all)
                .environmentObject(mapData)
                .ignoresSafeArea(.all, edges: .all)
                .overlay(
                    //MapViewAlTEST(bubbleDistanceValues: bubbleDistanceValues).clipShape(Rectangle()).environmentObject(mapData)).opacity(0.5).edgesIgnoringSafeArea(.all)
                    
                    Rectangle()
                            .fill(.white)
                            .frame(width: circleValue, height: circleValue)
                            .edgesIgnoringSafeArea(.all)
                            .shadow(radius: 1.5)
                            .overlay(
                                
                                MapViewALT(bubbleDistanceValues: bubbleDistanceValues).clipShape(Rectangle()).environmentObject(mapData)).edgesIgnoringSafeArea(.all)
                                 
               )
                            //.overlay(MapViewAlTEST(bubbleDistanceValues: bubbleDistanceValues).clipShape(Circle()).environmentObject(mapData)))
                          
                .overlay(
                    
                    ZStack {
             
                        
                        BubbleView(playerCoordinate2D: bubbleDistanceValues.userLocationUpdated ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), playerBearing: bubbleDistanceValues.userHeadingUpdated, bubbleLocation: CLLocationCoordinate2D(latitude: 51.21619846300433, longitude: 6.772556188340584), pixelsPerMeters: bubbleDistanceValues.pixelsPerMetersMAIN, sizePlaceholder: 30, colourPlaceholder: .yellow)
                        
                        
                        BubbleView(playerCoordinate2D: bubbleDistanceValues.userLocationUpdated ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), playerBearing: bubbleDistanceValues.userHeadingUpdated, bubbleLocation: CLLocationCoordinate2D(latitude: 51.21595226586471, longitude: 6.771729993062272), pixelsPerMeters: bubbleDistanceValues.pixelsPerMetersMAIN, sizePlaceholder: 10, colourPlaceholder: .green)
                        
                        BubbleView(playerCoordinate2D: bubbleDistanceValues.userLocationUpdated ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), playerBearing: bubbleDistanceValues.userHeadingUpdated, bubbleLocation: CLLocationCoordinate2D(latitude: 51.216227, longitude: 6.771682), pixelsPerMeters: bubbleDistanceValues.pixelsPerMetersMAIN, sizePlaceholder: 30, colourPlaceholder: .blue)
                        
                        BubbleView(playerCoordinate2D: bubbleDistanceValues.userLocationUpdated ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), playerBearing: bubbleDistanceValues.userHeadingUpdated, bubbleLocation: CLLocationCoordinate2D(latitude:  51.215446, longitude: 6.77136), pixelsPerMeters: bubbleDistanceValues.pixelsPerMetersMAIN, sizePlaceholder: 50, colourPlaceholder: .red)
                        
                        VStack {
                            Text("GROSS-HöhenM: \(bubbleDistanceValues.distanceInMetersMAIN),StartDiagonale: \(bubbleDistanceValues.diagonalScreenMetersMAIN)")
                            Text("KLEIN-HöhenM: \(bubbleDistanceValues.distanceInMetersALT),StartDiagonale: \(bubbleDistanceValues.diagonalScreenMetersALT)")
                            Text("groundMPerDistanceMMain: \(bubbleDistanceValues.groundMPerDistanceMMain), groundMPerDistanceMALT: \(bubbleDistanceValues.groundMPerDistanceMALT)")
                           
                        }
                    }
                )
            
            
            VStack {
                HStack {
                    Button {
                        if circleValue >= 20 {
                            circleValue -= 20
                        }
                       
                    } label: {
                        Text("smallerC").font(.title2)
                    }.padding(.trailing, 20)
                    
                    
                    Button {
                        circleValue += 20
                    } label: {
                        Text("smalerB").font(.title2)
                    }.padding(.leading, 20)
                }
                Spacer()
                HStack {
                    
                    Button {
                        mapData.adjustWatchdistance(higher: false)
                 
                        /*
                        if mapData.watchDistance > 15 {
                         mapData.watchDistance -= 15
                        }
                        */
                        
                        
                        
                        //mapData.adjustWatchdistance(higher: false, meters: 100)
                        /*
                        if bubbleDistanceValues.watchDistance > 30 {
                            mapData.watchDistance -= 30
                            bubbleDistanceValues.watchDistance -= 30
                        }
                        */
                        
                    } label: {
                        Text("LOWER").font(.title2)
                    }.padding(.trailing, 20)
                    
                    
                    Button {
                       // mapData.adjustWatchdistance(higher: true)
                        mapData.adjustWatchdistanceTWO()
                        /*
                        mapData.watchDistance += 15
                        */
                        
                        
                        /*
                        mapData.watchDistance += 30
                        bubbleDistanceValues.watchDistance += 30
                        */
                        
                        
                       // mapData.adjustWatchdistance(higher: true, meters: 100)
                    
                        
                        
                    } label: {
                        Text("HIGHER").font(.title2)
                    }.padding(.leading, 20)
                    
                }.padding(.bottom, 50)
            }
            
        
            
        }
       
        .onChange(of: mapData.currentSpeed) { value in
            bubbleDistanceValues.currentSpeed = value
        }
        .onReceive(bubbleDistanceValues.$distanceInMetersMAIN) { value in
            if mapData.bootPhase == false {
            //  mapData.currentDistanceMain = value
          }
        }
        .onReceive(bubbleDistanceValues.$distanceInMetersALT) { value in
            if mapData.bootPhase == false {
             //  mapData.currentDistanceALT = value
           }
        }
     
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



/*
  
 VStack {
     HStack {
         Button("START-TEST") {
             mapData.startTestTimers()
         }
         Button("STOP-TEST") {
             mapData.stopTestTimers()
         }
     }
     Text("ONE: \(mapData.timerTestONE)")
     Text("TWO: \(mapData.timerTestTWO)")
     Text("THREE: \(mapData.timerTestTHREE)")
     Text("FOUR: \(mapData.timerTestFOUR)")
     
 }
 
 
*/
