import Foundation

class YCPResponseFactory {
    static func getResponse(json: String) throws -> YCPResponse {
        let jsonResponse = JSON((json.data(using: .utf8))!)
                
        //Response when 3DS is disabled
        if jsonResponse["success"].exists() {
            let response = YCPResponseSale()
            response.success = jsonResponse["success"] != .null ? jsonResponse["success"].boolValue : false
            response.message = jsonResponse["message"].stringValue
            response.transactionId = jsonResponse["transaction_id"].stringValue
            
            return response
        }
        
        //Response when payment is protected by 3DSecure
        if jsonResponse["redirect_url"].exists() && jsonResponse["return_url"].exists() {
            let response = YCPResponse3ds()
            response.redirectUrl = jsonResponse["redirect_url"].stringValue
            response.returnUrl = jsonResponse["return_url"].stringValue
            response.transactionId = jsonResponse["transaction_id"].stringValue
            
            return response
        }
        
        throw NSError(domain: "Error occurred while decoding data", code:-1, userInfo:nil)
    }
}
