//Enums can participate in protocol witness matching, which matches requirements of protocols more easily.
//Proposal: SE-0280
// https://github.com/apple/swift-evolution/blob/main/proposals/0280-enum-cases-as-protocol-witnesses.md

protocol Defaultable {
    static var defaultValue: Self { get }
}

// make integers have a default value of 0
extension Int: Defaultable {
    static var defaultValue: Int { 0 }
}

// make arrays have a default of an empty array
extension Array: Defaultable {
    static var defaultValue: Array { [] }
}

// make dictionaries have a default of an empty dictionary
extension Dictionary: Defaultable {
    static var defaultValue: Dictionary { [:] }
}

enum Padding: Defaultable {
    case pixels(Int)
    case cm(Int)
    case defaultValue
}
