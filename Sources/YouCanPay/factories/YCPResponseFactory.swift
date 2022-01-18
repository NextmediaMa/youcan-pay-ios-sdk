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
        
        if jsonResponse["token"].exists() {
            let response = YCPResponseCashplus()
            response.token = jsonResponse["token"].stringValue
            response.transactionId = jsonResponse["transaction_id"].stringValue
            
            return response
        }
        
        throw YCPInvalidJsonException()
    }
    
    static func getConfigResponse(json: String) throws -> YCPAccountConfig {
        let jsonResponse = JSON((json.data(using: .utf8))!)
        
        if jsonResponse["acceptsCashPlus"].exists() {
            var ycpConfig = YCPAccountConfig()
            ycpConfig.acceptsCreditCards = jsonResponse["acceptsCreditCards"] != .null ? jsonResponse["acceptsCreditCards"].boolValue : false
            ycpConfig.acceptsCashPlus = jsonResponse["acceptsCashPlus"] != .null ? jsonResponse["acceptsCashPlus"].boolValue : false
            ycpConfig.cashPlusTransactionEnabled = jsonResponse["cashPlusTransactionEnabled"] != .null ? jsonResponse["cashPlusTransactionEnabled"].boolValue : false
            
            return ycpConfig
        }
        
        throw YCPInvalidJsonException()
    }
}
