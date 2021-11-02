import Foundation

class YCPResponseSale: YCPResponse {
    var transactionId: String = ""
    var success: Bool = false
    var message: String = ""
    var callbackInvoked: Bool = false
    
    init() {
    }
    
    init(success: Bool, message: String = "", transactionId: String = "") {
        self.success = success
        self.message = message
        self.transactionId = transactionId
    }
    
}
