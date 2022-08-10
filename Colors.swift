
// SWIFTUI:
// SET BACKGROUND COLOR TO A LINEAR GRADIENT EXAMPLE.
 .background( LinearGradient(
                        colors: [.orange, .red],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))


// ################## ADD COLORS TO UICOLOR DEFAULT COLORS ##########################

public extension UIColor {
    class var main: UIColor {
        return UIColor(red: 240.0 / 255.0, green: 101.0 / 255.0, blue: 8.0 / 255.0, alpha: 1.0)
    }
    
    class func main(alpha: CGFloat) -> UIColor {
        return UIColor(red: 240.0 / 255.0, green: 101.0 / 255.0, blue: 8.0 / 255.0, alpha: alpha)
    }
    
    class var darkBackground: UIColor {
        return UIColor(red: 10.0 / 255.0, green: 10.0 / 255.0, blue: 10.0 / 255.0, alpha: 1.0)
    }
    
    class var lightBackground: UIColor {
        return UIColor(red: 245.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
    }
    
    class var greenPastel: UIColor {
        return UIColor(red: 0.0 / 255.0, green: 169.0 / 255.0, blue: 108.0 / 255.0, alpha: 1.0)
    }
}

// ##### SWIFTUI USAGE:  
.background(Color(uiColor: .greenPastel) )

