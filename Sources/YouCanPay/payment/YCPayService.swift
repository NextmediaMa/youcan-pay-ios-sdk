import Foundation
#if !os(tvOS)
import UIKit
#endif

class YCPayService {
    var ycpHttpAdapter: YCPHttpAdapter
    
    init(httpAdapter: YCPHttpAdapter) {
        self.ycpHttpAdapter = httpAdapter
    }
    
    /// Called to send data to YCP
    /// - Parameter params : request parameters
    /// - Parameter isSandboxModeActived : boolean indicate if sandbox mode is actived or not
    /// - Parameter target : view for displaying the 3DS page
    /// - Parameter onSuccess : Called when the payment is succeded
    /// - Parameter onFailure: Called when the payment is failed
    func post(_ params: [String: Any],
              _ isSandboxMode: Bool,
              _ target: UIViewController?,
              _ onSuccess: @escaping (String) -> Void,
              _ onFailure: @escaping (String) -> Void)
    {
        DispatchQueue.main.async(execute: { () -> Void in
            let payUrl = isSandboxMode ? YCPConfigs.PAY_SANDBOX_URL : YCPConfigs.PAY_URL
            
            self.ycpHttpAdapter.post(payUrl, params, nil, { (ycpResponse) in
                if !ycpResponse.isSuccess() {
                    onFailure(ycpResponse.getResponse() ?? YCPLocalizable.get("An error occurred while processing the payment."))
                    
                    return
                }
                
                if ycpResponse.getResponse() == nil {
                    onFailure(YCPLocalizable.get("An error occurred while processing the payment."))
                    
                    return
                }
                
                do{
                    let response = try YCPResponseFactory.getResponse(json: ycpResponse.getResponse()!)
                    if ycpResponse.getStatusCode() != 200 {
                        ///Unsuccessful response
                        if let message = (response as? YCPResponseSale)?.message, !message.isEmpty {
                            onFailure(message)
                            
                            return
                        }
                        onFailure(YCPLocalizable.get("An error occurred while processing the payment."))
                        
                        return
                    }
                    
                    //Response when 3DS is disabled && success is true
                    if response is YCPResponseSale && (response as! YCPResponseSale).success {
                        onSuccess((response as! YCPResponseSale).transactionId)
                        
                        return
                    }
                    
                    //Response when payment is protected by 3DSecure
                    if response is YCPResponse3ds {
                        self.handleResult((response as! YCPResponse3ds), target, onSuccess, onFailure)
                        
                        return
                    }
                    onFailure(YCPLocalizable.get("An error occurred while processing the payment."))
                    
                    return
                } catch {
                    onFailure(error.localizedDescription)
                }
            })
        })
    }
    
    /// handling result in 3ds case
    func handleResult(_ response: YCPResponse3ds,
                      _ target: UIViewController?,
                      _ onSuccess: @escaping (String) -> Void,
                      _ onFailure: @escaping (String) -> Void)
    {
        if let target = target {
            DispatchQueue.main.async(execute: { () -> Void in
                let vc = YCPViewController(response, onSuccess, onFailure)
                target.present(vc, animated: true, completion: nil)
            })
        }
    }
}
