import Foundation
#if !os(tvOS)
import WebKit
#endif

public class YCPay {
    
    public var pubKey: String?
    public var token: String?
    public var paymentCallback = YCPaymentCallback()
    public var isSandboxModeActived = false
    
    // Consutructor to initialize YCPay
    public init(pubKey: String, token: String) {
        self.pubKey = pubKey
        self.token = token
    }
    
    // Call this func to proceed payment
    /// - Parameter cardInfo : contains all client infos
    /// - Parameter completionHandler: Called with the result of the payment
    public func pay(_ cardInfo: YCPCardInformation, _ completionHandler: @escaping (YCPResult) -> Void) throws {
        if pubKey == nil && pubKey?.count == 0 {
            throw NSError(domain: "Invalid pubKey", code:-1, userInfo:nil)
        }
        
        if token == nil && token?.count == 0 {
            throw NSError(domain: "Invalid token", code:-1, userInfo:nil)
        }
        
        let params = [
            "card_holder_name":   "\(cardInfo.cardHolderName)",
            "cvv":  "\(cardInfo.cvv)",
            "credit_card": "\(cardInfo.cardNumber)",
            "expire_date": "\(cardInfo.expireDate)",
            "token_id": "\(token!)",
            "pub_key": "\(pubKey!)",
            "is_mobile": 1
        ] as [String : Any]
        
        /// start the payment by sending card info to YCPay API
        if isSandboxModeActived {
            YCPayService.sendCardInfoSandboxMode(params, completionHandler)
            return
        }
        
        YCPayService.sendCardInfo(params, completionHandler)
    }
    
    // set sandbox mode
    public func setSandboxMode(_ isSandboxModeActived: Bool){
        self.isSandboxModeActived = isSandboxModeActived
    }
}
