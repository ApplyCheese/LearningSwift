
import Foundation

protocol Onomable{
    var onoma: Onomata {get}
}

enum OnomaDataError: Error{
    case OnomataNotEqual
}

struct Combining<T>{
    let combine: (T,T) -> T
} // Combining
// Protocol witness

let onomaSum = Combining<Onomata> { $0.union($1) } // removes Dup's

// Add function to all arrays
extension Array{
    func onomareduce(_ initial: Element, _ combining: Combining<Element>) -> Element {
        return self.reduce(initial, combining.combine)
    }
}


@propertyWrapper struct Check_Onoma{
   
    private let data: (Onomata, [Onomable])

    var wrappedValue: (Onomata, [Onomable]){
        get{
            data
        }
    } // wrappedValue
    
    init(wrappedValue: (Onomata, [Onomable])){
        let onoma_A = wrappedValue.0
        var onoma_B = Onomata.none
        for x in wrappedValue.1{
            onoma_B = onoma_B.union(x.onoma)
            print("union: \(x.onoma)")
        } // for
        print("onoma_B: \(onoma_B)")
        if onoma_A == onoma_B{
            data = wrappedValue
        } else {
           fatalError("CHECK_ONOMA: Onoma doesn't match.")
        } // else
      
    } // init
    
} // Check_Onoma

struct OnomatedData{
   @Check_Onoma var data: (Onomata, [Onomable])
}


struct Onomata: OptionSet, SetAlgebra, Hashable {
    // Max is 56. Fixed width of Int. 0000x56
    let rawValue: Int
    static let none = Onomata(rawValue: 0 << 0)
    
    static let priceViewModel                = Onomata(rawValue: 1 << 0)
    static let locationManager               = Onomata(rawValue: 1 << 1)
    static let scatterImagePickerViewModel   = Onomata(rawValue: 1 << 2)
    
    static let testme: Onomata               = [.priceViewModel, .scatterImagePickerViewModel, .locationManager]
    static let realEstatePAB: Onomata        = [.priceViewModel, .scatterImagePickerViewModel, .locationManager].onomareduce(.none, onomaSum)
   
} // ViewPath



  AutoOnoma.swift
  Test_ScatterManager

  Created by Todd Sleeman on 2/16/23.


import Foundation
import CoreLocation
import UIKit
import MapKit // CLLocationCoordinate2D

NOTE: AUTOONOMA IS AUTO = GREEK:"SELF" & ONOMA = GREEK:"NAME"
/*
 AUTOONOMA SCATTER WILL NAME STRUCTS USING THERE properties.
 */


/// Named things or  things that have been named
enum Onomata{
    
    case uiimage
    
} // Onomata


/// Name-able
protocol Onomable{
    
    var onomaCategory: Onomata {get}
    
} // Onomable


/// Name-able Image
protocol OnomatedUIImage: Onomable {
    
    typealias ItemIdentification = String

    var id: ItemIdentification {get}
    var image: UIImage {get}
    var location: String {get}
    var unit: String {get}
    
} // AutoonomaableImage


extension OnomatedUIImage{
    
    var onomaCategory: Onomata {
    
        Onomata.uiimage
        
    } // autoonomaType
    
} // extension

enum Autonoma{
    
    static var save: (Onomable) -> String { { onomated in
        switch onomated.onomaCategory {
        
        case .uiimage:
            if onomated is OnomatedUIImage {
                let onomateduiimage = onomated as! OnomatedUIImage
                // TODO: SAVE TO DIR.PHOTOS
                
                return "\( onomateduiimage.image )+\( onomateduiimage.location )=\( onomateduiimage.unit )"
            } // if
            return "Not found"
        } // switch
        
    } // closure
        
    } // save
} // Autonoma


/*
 func autoonoma(location: CLLocation, unit: String) -> String{

      let long4 = String(String(location.coordinate.longitude).suffix(4))
      let lat4 = String(String(location.coordinate.latitude).suffix(4))
       file name: long+Lat + 4x4
      let filename = locationToString(Location: location.coordinate.longitude) +
      locationToString(Location: location.coordinate.latitude) +
      long4 + lat4 + unit
      print("fileName: \(filename)" )
      return filename
  }

  /Formats a Double to a String to 2 decimal places and replaces ". -> x"  and "- -> n".
 private func locationToString(Location: Double) -> String{

      NOTE: This will not be an issuse for location searches. Location Searches add +/- 0.001 to center location
      String(format: "%.4f", Location).dropLast(2)
          .replacingOccurrences(of: ".", with: "x").replacingOccurrences(of: "-", with: "n")

  }  locationToString
 */
