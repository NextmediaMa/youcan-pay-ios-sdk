import Foundation
#if !os(tvOS)
import WebKit
#endif

public class YCPay {
    public var pubKey: String
    public var token: String?
    public var isSandboxMode = false
    private var ycpayService: YCPayService
    private var ycpConfigService: YCPConfigService
    public var ycpAccountConfig = YCPAccountConfig()
    public var isLoading = Observable<Bool>()
    
    // Consutructor to initialize YCPay
    public init(pubKey: String, locale: String = "en") {
        self.pubKey = pubKey
        self.isLoading.property = false
        YCPLocalizable.setCurrentLocale(locale: locale)
        self.ycpayService = YCPayService(httpAdapter: YCPAlamofireAdapter())
        self.ycpConfigService = YCPConfigService(httpAdapter: YCPAlamofireAdapter())
        // call config endpoint
        self.getAccountConfig()
    }
    
    // Called to get account config
    private func getAccountConfig() {
        self.ycpConfigService.getConfig("\(YCPConfigs.CONFIG_URL)/\(self.pubKey)", { (accountConfig) in
            self.ycpAccountConfig = accountConfig
            self.isLoading.property = true
        }, { (error) in
            print(error)
            self.isLoading.property = true
        })
    }
   
    // Call this func to proceed payment with credit card
    /// - Parameter token : Token for the current transaction
    /// - Parameter cardInfo : Contains card information
    /// - Parameter onSuccess : Called when the payment is succeded
    /// - Parameter onFailure: Called when the payment is failed
    public func payWithCreditCard(_ token: String,
                    _ cardInfo: YCPCardInformation,
                    _ target: UIViewController,
                    _ onSuccess: @escaping (String) -> Void,
                    _ onFailure: @escaping (String) -> Void) throws
    {
        if !self.ycpAccountConfig.acceptsCreditCards {
            throw YCPInvalidPaymentMethodException()
        }
        
        let endpoint = self.isSandboxMode ? YCPConfigs.PAY_SANDBOX_URL : YCPConfigs.PAY_URL
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
        self.ycpayService.post(endpoint, params, target, onSuccess, onFailure)
    }
    
    // Call this func to proceed payment with cash plus
    /// - Parameter token : Token for the current transaction
    /// - Parameter onSuccess : Called when the payment is succeded
    /// - Parameter onFailure: Called when the payment is failed
    public func payWithCashPlus(_ token: String,
                    _ onSuccess: @escaping (String) -> Void,
                    _ onFailure: @escaping (String) -> Void) throws
    {
        if !self.ycpAccountConfig.acceptsCashPlus {
            throw YCPInvalidPaymentMethodException()
        }
        
        let endpoint = YCPConfigs.PAY_CASHPLUS_URL
        let params = [
            "token_id": "\(token)",
            "pub_key": "\(self.pubKey)"
        ] as [String : Any]
            
        /// start the payment with cashplus
        self.ycpayService.post(endpoint, params, nil, onSuccess, onFailure)
    }
    
    // set sandbox mode
    public func setSandboxMode(_ isSandboxMode: Bool) {
        self.isSandboxMode = isSandboxMode
    }
}
