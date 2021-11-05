import Foundation

class YCPCardValidation {
    class func validate(_ cardInfo: YCPCardInformation) throws {
        if !isValidCardName(cardInfo.cardHolderName) {
            throw YCPInvalidArgumentException(message: "Cardholder name is required")
        }
        
        if !isValidCardNumber(cardInfo.cardNumber) {
            throw YCPInvalidArgumentException(message: "Invalid card number")
        }
        
        if !isValidDate(cardInfo.expiryDate) {
            throw YCPInvalidArgumentException(message: "Invalid date")
        }
        
        if !isValidCvv(cardInfo.cvv) {
            throw YCPInvalidArgumentException(message: "Invalid cvv")
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

extension String {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
