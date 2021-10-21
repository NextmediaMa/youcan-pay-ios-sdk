import Foundation

public class YCPaymentCallback : NSObject {
    
    var callbackUrl: String?
    var transactionId: String?
    var headerParams: YCParameters?
    
    public func create(callbackUrl: String, transactionId: String, headerParams: YCParameters? = nil) {
        self.callbackUrl = callbackUrl
        self.transactionId = transactionId
        self.headerParams = headerParams
    }
    
    public func call(onSuccess: @escaping (YCPaymentStatus) -> Void = {_ in } ,onFailure: @escaping (NSError) -> Void = {_ in }) throws {
        
        guard let callbackUrl = callbackUrl else {
            throw NSError(domain: "Invalid callback url", code:-1, userInfo:nil)
        }
        guard let transactionId = transactionId else {
            throw NSError(domain: "Invalid transaction id", code:-1, userInfo:nil)
        }
        
        let params = [
            "transaction_id":   "\(transactionId)",
            "mobile":   "1"
        ]
        
        //allows you to retrieve the payment status
        YCPaymentCallbackService.getResponse(callbackUrl, params, headerParams, completion: {(result, error) in
            if let result = result {
                ///Matching YCPaymentStatus Values with a Switch Statement
                switch result.status {
                case YCPaymentStatus.pending.rawValue:
                    onSuccess(YCPaymentStatus.pending)
                case YCPaymentStatus.canceled.rawValue:
                    onSuccess(YCPaymentStatus.canceled)
                case YCPaymentStatus.success.rawValue:
                    onSuccess(YCPaymentStatus.success)
                default:
                    print("event not handled")
                }
                return
            }
            
            if let error  = error {
                onFailure(error)
            }
        })
    }
    
}
