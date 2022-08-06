
// @Main app root file example

import SwiftUI

@main
struct ExampleApp: App {
  
    // Create a UIKit app delegate to handle app delegate callbacks.
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate 
  
    var body: some Scene {
        WindowGroup {
          
            ContentView()
              .onAppear {
                
                // Sets the property of the receiver specified|UIInterfaceOrientation by a given key to a given value.
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")// Set Portrait
                AppDelegate.orientationLock = .portrait //  Lock it to portrait
                
              /* Support multiple orientation values.
                AppDelegate.orientationLock = ( UIInterfaceOrientationMask(
                                          rawValue: UIInterfaceOrientationMask.portrait.rawValue | 
                                          UIInterfaceOrientationMask.landscape.rawValue | 
                                          UIInterfaceOrientationMask.portraitUpsideDown.rawValue) 
                                         ) // UIInterfaceOrientationMask
              // */

            } // onAppear
        } // WindowGroup
    } // body
} // ExampleApp


class AppDelegate: NSObject, UIApplicationDelegate {
    
    /// Constants that specify a view controller’s supported interface orientations.
    static var orientationLock = UIInterfaceOrientationMask.all // Set default to:  all views can rotate

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}


