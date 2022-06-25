//
//  NewMapApp.swift
//  NewMap
//
//  Created by Maximilian Löhr on 30.03.22.
//

import SwiftUI

@main
struct NewMapApp: App {
    
   
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate   {
    
    static var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIDevice.current.userInterfaceIdiom == .phone ? .portrait : .portrait
    }
}
