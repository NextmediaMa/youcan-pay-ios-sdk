import Foundation

class YCPCardValidation {
    class func validate(_ cardInfo: YCPCardInformation) throws {
        if !isValidCardName(cardInfo.cardHolderName) {
            throw NSError(domain: "Cardholder name is required", code:-1, userInfo:nil)
        }
        
        if !isValidCardNumber(cardInfo.cardNumber) {
            throw NSError(domain: "Invalid card number", code:-1, userInfo:nil)
        }
        
        if !isValidDate(cardInfo.expiryDate) {
            throw NSError(domain: "Invalid date", code:-1, userInfo:nil)
        }
        
        if !isValidCvv(cardInfo.cvv) {
            throw NSError(domain: "Invalid cvv", code:-1, userInfo:nil)
        }
    }
    
    private class func isValidCardName(_ cardholderName: String) -> Bool {
        if cardholderName.isEmpty {
            return false
        }
        return true
    }
    
    private class func isValidCardNumber(_ number: String) -> Bool {
        if number.isEmpty || !number.isNumber {
            return false
        }
        
        return true
    }
    
    private class func isValidDate(_ cardExpiryDate: String) -> Bool {
        if cardExpiryDate.isEmpty {
            return false
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        let enteredDate = dateFormatter.date(from: cardExpiryDate)!
        let endOfMonth = Calendar.current.date(byAdding: .month, value: 1, to: enteredDate)!
        let now = Date()
        
        if (endOfMonth < now) {
            return false
        }
        
        return true
    }
    
    private class func isValidCvv(_ number: String) -> Bool {
        if number.isEmpty || !number.isNumber {
            return false
        }
        
        return true
    }
}

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
