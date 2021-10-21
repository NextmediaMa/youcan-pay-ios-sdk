import Foundation

public class YCPayService : NSObject {
    
    static var threeDS: YCPThreeDSecure?
    
    /// Called to send data to YCP
    /// - Parameter params : request parameters
    /// - Parameter completionHandler: Called with the result of the request
    public static func sendCardInfo(_ params: [String: Any], _ completionHandler: @escaping (YCPResult) -> Void) {
        ///Making the payment, which holds two possibilities: Either the card of payment is protected by 3DSecure or not
        DispatchQueue.main.async(execute: { () -> Void in
            YCPHttpRequest.post(url : YCPConfigs.PAY_URL, params: params).responseJSON { (responseData) -> Void in
                switch responseData.result {
                ///Handling Successful Responses with “.success(value)”
                case let .success(value):
                    let response = JSON(value)
                    
                    if responseData.response?.statusCode != 200 {
                        ///Unsuccessful response
                        if response["message"].exists() {
                            completionHandler(YCPResult(false, response["message"].stringValue))
                            return
                        }
                        
                        completionHandler(YCPResult(false, "An error occurred while processing the payment."))
                        return
                    }
                    
                    //Response when 3DS is disabled
                    if response["success"].exists() && response["success"].boolValue {
                        completionHandler(YCPResult(true))
                        return
                    }
                    
                    //Response when payment is protected by 3DSecure
                    if response["redirect_url"].exists() && response["return_url"].exists() {
                        let tDS = YCPThreeDSecureFactory.parseJson(jData: response)
                        
                        var result = YCPResult(true)
                        result.is3DS = true
                        result.threeDsPage = tDS.redirectUrl
                        result.callBackUrl = tDS.returnUrl
                        completionHandler(result)
                        return
                    }
                    
                    completionHandler(YCPResult(false, "An error occurred while processing the payment."))
                    
                ///Handling failure Responses with “.failure(error)”
                case let .failure(error):
                    print(error)
                    completionHandler(YCPResult(false, error.localizedDescription))
                }
            }
        })
    }
    
    /// Called to send data to YCP using sandbox mode
    /// - Parameter params : request parameters
    /// - Parameter completionHandler: Called with the result of the request
    public static func sendCardInfoSandboxMode(_ params: [String : Any], _ completionHandler: @escaping (YCPResult) -> Void) {
        ///Making the payment, which holds two possibilities: Either the card of payment is protected by 3DSecure or not
        
        DispatchQueue.main.async(execute: { () -> Void in
            YCPHttpRequest.post(url : YCPConfigs.PAY_SANDBOX_URL, params: params).responseJSON { (responseData) -> Void in
                switch responseData.result {
                ///Handling Successful Responses with “.success(value)”
                case let .success(value):
                    let response = JSON(value)
                    
                    if responseData.response?.statusCode != 200 {
                        ///Unsuccessful response
                        if response["message"].exists() {
                            completionHandler(YCPResult(false, response["message"].stringValue))
                            return
                        }
                        
                        completionHandler(YCPResult(false, "An error occurred while processing the payment."))
                        return
                    }
                    
                    //Response when 3DS is disabled
                    if response["success"].exists() && response["success"].boolValue {
                        completionHandler(YCPResult(true))
                        return
                    }
                    
                    if response["transaction_id"].exists() && response["return_url"].exists() {
                        //Response when payment is protected by 3DSecure
                        threeDS = YCPThreeDSecureFactory.parseJson(jData: response)
                        if let tDS = threeDS {
                            get3dsPage(tDS, completionHandler)
                            return
                        }
                    }
                    
                    completionHandler(YCPResult(false, "An error occurred while processing the payment."))
                    
                ///Handling failure Responses with “.failure(error)”
                case let .failure(error):
                    print(error)
                    completionHandler(YCPResult(false, error.localizedDescription))
                }
            }
        })
    }
    
    /// Called to retrieve the 3DS page
    /// - Parameter cardInfo : contains all client infos
    /// - Parameter completionHandler: Called with the result of the request
    public class func get3dsPage(_ threeDS: YCPThreeDSecure, _ completionHandler: @escaping (YCPResult) -> Void) {
        ///Making just the payment who  protected by 3DSecure
        DispatchQueue.main.async(execute: { () -> Void in
            let params = [
                "PaReq":   "\(threeDS.paReq)",
                "MD":  "\(threeDS.transactionId)",
                "TermUrl": "\(threeDS.returnUrl)"
            ]
            
            YCPHttpRequest.post(url: threeDS.redirectUrl, params: params).responseString { (responseData) -> Void in
                // When download completes,control flow goes here.
                
                switch responseData.result {
                ///Handling Successful Responses with “.success(value)”
                case let .success(value):
                    let response = value
                    if( responseData.response?.statusCode == 200){
                        var result = YCPResult(true)
                        result.is3DS = true
                        result.threeDsPage = response
                        result.callBackUrl = threeDS.listenUrl
                        result.sandboxModeActived = true
                        completionHandler(result)
                        return
                    }
                    
                    var result = YCPResult(false)
                    result.is3DS = true
                    completionHandler(result)
                    
                ///Handling Successful Responses with “.failure(error)”
                case let .failure(error):
                    print(error)
                }
            }
        })
    }
}
