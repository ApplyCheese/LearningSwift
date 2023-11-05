
import Foundation
import SwiftUI

protocol Routeable: Codable, Hashable {}


class Router: ObservableObject {
  
    @Published var navigationPath = NavigationPath() {
         // NOTE: Not required, just a example of how to add animation to navigationPath changes.
        //MARK: ADD ANIMATION TO CHANGES IN NAVIGATIONPATH
        willSet(newPath){
            if newPath.count < navigationPath.count - 1 {
                let animation = CATransition()
                animation.isRemovedOnCompletion = true
                animation.type = .moveIn
                animation.duration = 0.4
                animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                UIApplication
                    .shared
                    .connectedScenes
                    .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                    .last?
                    .layer
                    .add(animation, forKey: nil)
            } // if
        } // willSet
        
        // MARK: SAVE WHEN CHANGES HAPPEN TO NAVIGATIONPATH
        didSet {
            save()
        } // didSet
    } // navigationPath

    // MARK: URL TO SAVE NAVIGATIONPATH TO.
    private let savePath = URL.documentsDirectory.appending(path: "SavedNavigationPath")

    // MARK: INIT
    init() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
                navigationPath = NavigationPath(decoded)
                return
            } // decoded
        } // data
    } // init

    // MARK: METHODS
    func save() {
        guard let representation = navigationPath.codable else { return }
        do {
            let data = try JSONEncoder().encode(representation)
            try data.write(to: savePath)
        } catch {
            print("Failed to save navigation data")
        } // do|catch
    } // save

  // Return to root view
    func home() {
        navigationPath = NavigationPath()
    } // reset

  // Go back to where you just navigated from
   func back(){
       if navigationPath.count > 0{
           navigationPath.removeLast()
       } // if
   }// backone

  // push view onto the navigationPath
    func pushView(route: any Routeable ){
       navigationPath.append( route )
   } // pushView
    
} // Router
