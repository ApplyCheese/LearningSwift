
import Foundation

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
