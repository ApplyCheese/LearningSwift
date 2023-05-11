
func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }


func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }


// For use in an Enum.  
// MARK: IS VALID PHONE DIGITS
    /// Requires 10 digits only
    static func isValidPhoneDigits( phone: String) -> Bool {

        var numbers = "0123456789"
        // ====================
        let filtered = phone.filter { numbers.contains($0)}
        if filtered.count == 10 {
            return true
        }
        return false
    }

  // MARK: EMAIL VALIDATOR
    /// Returns a tuple with a 0: String & 1: Bool.
    /// String is for EntryField prompt and Bool isEmailValid return.
    static func emailValidator(_ email: String) -> (String, Bool){
        
        if IMS.isEmailValid(email) {
            return  (String.defaultValue, true)
        } else {
            return ("Enter a valid email address", false)
        } // IF/ELSE
        
    } // emailValidator
    
    
    // MARK: IS EMAIL VALID
    static func isEmailValid(_ email: String) -> Bool{
        
        // criteria in regex.  See http://regexlib.com
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "^((([!#$%&'*+\\-/=?^_`{|}~\\w])|([!#$%&'*+\\-/=?^_`{|}~\\w][!#$%&'*+\\-/=?^_`{|}~\\.\\w]{0,}[!#$%&'*+\\-/=?^_`{|}~\\w]))[@]\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*)$")
  
        return emailTest.evaluate(with: email)
    }
    
    // MARK: WEBSITE VALIDATOR
    static func websiteValidator(_ website: String) -> (String, Bool){
        
        if IMS.isWebsiteValid(website){
            return (String.defaultValue, true)
        } else {
            return ("Enter a valid wed address", false)
        }
    }
    
    // MARK: IS WEBSITE VALID
    static func isWebsiteValid(_ website: String) -> Bool{
        // TODO: TEST WEB RESPONSE TO CHECK WEB LINK FOR USER, NOT 404 AND RETURN STRING OF WEB RESPONSE AS RESULT.

        let websiteTest = NSPredicate(format: "SELF MATCHES %@",
             "(?<protocol>http(s)?|ftp)://(?<server>([A-Za-z0-9-]+\\.)*(?<basedomain>[A-Za-z0-9-]+\\.[A-Za-z0-9]+))+((/?)(?<path>(?<dir>[A-Za-z0-9\\._\\-]+)(/){0,1}[A-Za-z0-9.-/]*)){0,1}")
        return websiteTest.evaluate(with: "https://\(website)")
    }
