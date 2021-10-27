import Foundation
#if !os(tvOS)
import WebKit
#endif

public class YCPay {
    
    public var pubKey: String
    public var token: String?
    public var isSandboxModeActived = false
    
    // Consutructor to initialize YCPay
    public init(pubKey: String, locale: String = "en") {
        self.pubKey = pubKey
        YCPConfigs.CURRENT_LOCALE = locale
    }
   
    // Call this func to proceed payment
    /// - Parameter token : Token for the current transaction
    /// - Parameter cardInfo : Contains card information
    /// - Parameter onSuccess : Called when the payment is succeded
    /// - Parameter onFailure: Called when the payment is failed
    public func pay(_ token: String,
                    _ cardInfo: YCPCardInformation,
                    _ target: UIViewController,
                    _ onSuccess: @escaping (String) -> Void,
                    _ onFailure: @escaping (String) -> Void) throws
    {
        try YCPCardValidation.validate(cardInfo)
        
        if self.pubKey.isEmpty {
            throw NSError(domain: "Invalid pubKey", code:-1, userInfo:nil)
        }
        
        if token.isEmpty {
            throw NSError(domain: "Invalid token", code:-1, userInfo:nil)
        }
        
        let params = [
            "card_holder_name":   "\(cardInfo.cardHolderName)",
            "cvv":  "\(cardInfo.cvv)",
            "credit_card": "\(cardInfo.cardNumber)",
            "expire_date": "\(cardInfo.expiryDate)",
            "token_id": "\(token)",
            "pub_key": "\(self.pubKey)",
            "is_mobile": 1
        ] as [String : Any]
        
        /// start the payment by sending card info to YCPay API
        YCPayService.post(params, self.isSandboxModeActived, target, onSuccess, onFailure)
    }
    
    // set sandbox mode
    public func setSandboxMode(_ isSandboxModeActived: Bool) {
        self.isSandboxModeActived = isSandboxModeActived
    }
}
