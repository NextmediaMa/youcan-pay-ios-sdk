import Foundation

class YCPThreeDSecureFactory {
    static func parseJson(jData: JSON) -> YCPThreeDSecure {
        var threeDS = YCPThreeDSecure()
        threeDS.redirectUrl = jData["redirect_url"].stringValue
        threeDS.returnUrl = jData["return_url"].stringValue
        threeDS.transactionId = jData["transaction_id"].stringValue
        
        return threeDS
    }
}
