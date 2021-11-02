import Foundation

class YCPResponse3ds: YCPResponse {
    var transactionId: String = ""
    var redirectUrl: String  = ""
    var returnUrl: String  = ""
    
    init() {
    }
    
    init(redirectUrl: String, returnUrl: String, transactionId: String) {
        self.redirectUrl = redirectUrl
        self.returnUrl = returnUrl
        self.transactionId = transactionId
    }
}
