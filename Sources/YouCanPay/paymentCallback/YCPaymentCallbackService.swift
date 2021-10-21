import Foundation

public class YCPaymentCallbackService : NSObject {
    
    static func getResponse(_ callbackUrl: String,
                            _ params: [String : Any],
                            _ headerParams: YCParameters? = nil,
                            completion: @escaping YCPaymentCallbackCompletionBlock)
    {
        DispatchQueue.main.async(execute: { () -> Void in
            YCPHttpRequest.post(url: callbackUrl, params: params, headerParams: headerParams).responseJSON { (responseData) -> Void in
                switch responseData.result {
                ///Handling Successful Responses with “.success(value)”
                case let .success(value):
                    let response = JSON(value)
                    if( responseData.response?.statusCode != 200){
                        var error : NSError?
                        
                        if response["message"].exists() {
                            error = NSError(domain: "\(response["message"])", code: responseData.response?.statusCode ?? -1, userInfo:nil)
                        }
                        
                        error = NSError(domain: "An error occurred while retrieving the payment status.", code: responseData.response?.statusCode ?? -1, userInfo:nil)
                        
                        completion(nil, error)
                        return
                    }
                    
                    let result = YCPCallbackResultFactory.parseJson(jData: response)
                    completion(result, nil)
                    
                ///Handling Failure Responses with “.failure(error)”
                case let .failure(errorAf):
                    let error = NSError(domain: "\(errorAf)", code: responseData.response?.statusCode ?? -1, userInfo:nil)
                    completion(nil, error)
                }
            }
        })
    }
}

