import Foundation

///Data Model to handle the YCPCardInformation data
public struct YCPCardInformation: Codable {
    var cardHolderName: String = ""
    var cardNumber: String = ""
    var expiryDate: String = ""
    var cvv: String = ""
    
    public init(cardHolderName: String, cardNumber: String, expiryDate: String, cvv: String) throws {
        self.cardHolderName = cardHolderName
        self.cardNumber = cardNumber
        self.expiryDate = expiryDate
        self.cvv = cvv
        
        try YCPCardValidation.validate(self)
    }
}
