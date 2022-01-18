import Foundation
#if !os(tvOS)
import UIKit
#endif

class YCPConfigService {
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
    func getConfig(_ url: String,
              _ onSuccess: @escaping (YCPAccountConfig) -> Void,
              _ onFailure: @escaping (String) -> Void)
    {
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.ycpHttpAdapter.get(url, [:], nil, { (ycpResponse) in
                if ycpResponse.getStatusCode() != 200 {
                    onFailure(YCPLocalizable.get("An error occurred"))
                    
                    return
                }
                
                if !ycpResponse.isSuccess() {
                    onFailure(ycpResponse.getResponse() ?? YCPLocalizable.get("An error occurred"))
                    
                    return
                }
                
                if ycpResponse.getResponse() == nil {
                    onFailure(YCPLocalizable.get("An error occurred"))
                    
                    return
                }
                
                do{
                    let config = try YCPResponseFactory.getConfigResponse(json: ycpResponse.getResponse()!)
                    onSuccess(config)
                } catch {
                    onFailure(error.localizedDescription)
                }
            })
        })
    }
}
