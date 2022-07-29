

/// No Round removal of decimal places. MaxDecimals is where you want to cut the number off after.
func noRound(_ a: Double, maxDecimals max: Int) -> Double {
    let stringArr = String(a).split(separator: ".")
    let decimals = Array(stringArr[1])
    var string = "\(stringArr[0])."

    var count = 0;
    for n in decimals {
        if count == max { break }
        string += "\(n)"
        count += 1
    }


    let double = Double(string)!
    return double
}
