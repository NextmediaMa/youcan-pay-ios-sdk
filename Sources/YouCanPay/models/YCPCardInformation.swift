import Foundation

///Data Model to handle the YCPCardInformation data
public struct YCPCardInformation : Codable {
    var cardHolderName: String = ""
    var cardNumber: String = ""
    var expireDate: String = ""
    var cvv: String = ""
    
    public init() {
    }
    
    public init(cardHolderName: String, cardNumber: String, expireDate: String, cvv: String) {
        self.cardHolderName = cardHolderName
        self.cardNumber = cardNumber
        self.expireDate = expireDate
        self.cvv = cvv
    }
}
