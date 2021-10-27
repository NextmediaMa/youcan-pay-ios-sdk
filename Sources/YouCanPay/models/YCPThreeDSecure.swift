import Foundation

///Data Model to handle the YCPThreeDSecure data
struct YCPThreeDSecure: Codable {
    var redirectUrl: String  = ""
    var returnUrl: String  = ""
    var transactionId: String  = ""
    
    init() {
    }
    
    init(redirectUrl: String, returnUrl: String, transactionId: String) {
        self.redirectUrl = redirectUrl
        self.returnUrl = returnUrl
        self.transactionId = transactionId
    }
}
