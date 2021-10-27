import Foundation
#if !os(tvOS)
import UIKit
#endif

class YCPayService: NSObject {
    
    /// Called to send data to YCP
    /// - Parameter params : request parameters
    /// - Parameter isSandboxModeActived : boolean indicate if sandbox mode is actived or not
    /// - Parameter target : view for displaying the 3DS page
    /// - Parameter onSuccess : Called when the payment is succeded
    /// - Parameter onFailure: Called when the payment is failed
    static func post(_ params: [String: Any],
                     _ isSandboxModeActived: Bool,
                     _ target: UIViewController?,
                     _ onSuccess: @escaping (String) -> Void,
                     _ onFailure: @escaping (String) -> Void)
    {
        DispatchQueue.main.async(execute: { () -> Void in
            let payUrl = isSandboxModeActived ? YCPConfigs.PAY_SANDBOX_URL : YCPConfigs.PAY_URL
            YCPHttpRequest.post(url : payUrl, params: params).responseJSON { (responseData) -> Void in
                switch responseData.result {
                ///Handling Successful Responses with “.success(value)”
                case let .success(value):
                    let response = JSON(value)
                    
                    if responseData.response?.statusCode != 200 {
                        ///Unsuccessful response
                        if response["message"].exists() {
                            onFailure(response["message"].stringValue)
                            return
                        }
                        
                        onFailure(YCPLocalizable.get("An error occurred while processing the payment."))
                        return
                    }
                    
                    //Response when 3DS is disabled
                    if response["success"].exists() && response["success"].boolValue {
                        onSuccess(response["transaction_id"].stringValue)
                        return
                    }
                    
                    //Response when payment is protected by 3DSecure
                    if response["redirect_url"].exists() && response["return_url"].exists() {
                        let tDS = YCPThreeDSecureFactory.parseJson(jData: response)
                        
                        var result = YCPResult(false)
                        result.threeDS = tDS
                        result.isSandboxModeActived = isSandboxModeActived
                        handleResult(result, target, onSuccess, onFailure)
                        
                        return
                    }
                    
                    onFailure(YCPLocalizable.get("An error occurred while processing the payment."))
                    
                ///Handling failure Responses with “.failure(error)”
                case let .failure(error):
                    onFailure(error.localizedDescription)
                }
            }
        })
    }
    
    /// handling result in 3ds case
    static func handleResult(_ result: YCPResult,
                             _ target: UIViewController?,
                             _ onSuccess: @escaping (String) -> Void,
                             _ onFailure: @escaping (String) -> Void)
    {
        if let target = target {
            DispatchQueue.main.async(execute: { () -> Void in
                let vc = YCPViewController(result, onSuccess, onFailure)
                target.present(vc, animated: true, completion: nil)
            })
        }
    }
}
