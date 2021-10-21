import Foundation

///Data Model to handle the YCPThreeDSecure data
public struct YCPThreeDSecure : Codable {
    var redirectUrl: String  = ""
    var paReq: String  = ""
    var returnUrl: String  = ""
    var listenUrl: String = ""
    var transactionId: String  = ""
    
    init() {
    }
    
    init(redirectUrl: String, paReq: String, returnUrl: String, listenUrl: String, transactionId: String) {
        self.redirectUrl = redirectUrl
        self.paReq = paReq
        self.returnUrl = returnUrl
        self.listenUrl = listenUrl
        self.transactionId = transactionId
    }
}
