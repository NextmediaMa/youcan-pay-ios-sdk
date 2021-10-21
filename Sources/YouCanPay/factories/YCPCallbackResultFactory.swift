import Foundation

public class YCPCallbackResultFactory {
    public static func parseJson(jData: JSON) -> YCPCallbackResult {
        var callbackResult = YCPCallbackResult()
        callbackResult.id = jData["id"].stringValue
        callbackResult.orderId = jData["order_id"].stringValue
        callbackResult.amount = jData["amount"].doubleValue
        callbackResult.currency = jData["currency"].stringValue
        callbackResult.status = jData["status"].intValue
        callbackResult.createdAt = jData["created_at"].stringValue
        
        return callbackResult
    }
}
