import Foundation
#if !os(tvOS)
import WebKit
#endif

public class YCPay {
    public var pubKey: String
    public var token: String?
    public var isSandboxMode = false
    private var ycpayService: YCPayService
    
    // Consutructor to initialize YCPay
    public init(pubKey: String, locale: String = "en") {
        self.pubKey = pubKey
        YCPLocalizable.setCurrentLocale(locale: locale)
        ycpayService = YCPayService(httpAdapter: YCPAlamofireAdapter())
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
        self.ycpayService.post(params, self.isSandboxMode, target, onSuccess, onFailure)
    }
    
    // set sandbox mode
    public func setSandboxMode(_ isSandboxMode: Bool) {
        self.isSandboxMode = isSandboxMode
    }
}
