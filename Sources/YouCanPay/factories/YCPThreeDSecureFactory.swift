import Foundation

public class YCPThreeDSecureFactory {
    public static func parseJson(jData: JSON) -> YCPThreeDSecure {
        var threeDS = YCPThreeDSecure()
        threeDS.redirectUrl = jData["redirect_url"].stringValue
        threeDS.paReq = jData["PaReq"].stringValue
        threeDS.returnUrl = jData["return_url"].stringValue
        threeDS.listenUrl = jData["listen_url"].stringValue
        threeDS.transactionId = jData["transaction_id"].stringValue
        
        return threeDS
    }
}
