import Foundation

class YCPConfigs: NSObject {
    // root url
    static public let BASE_URL: String = "https://pay.youcan.shop"
    
    // pay url
    static public let PAY_URL: String = BASE_URL + "/api/pay"
    
    // pay url for sandbox mode
    static public let PAY_SANDBOX_URL: String = BASE_URL + "/sandbox/api/pay"
    
    // config url
    static public let CONFIG_URL: String = BASE_URL + "/api/get-account-configs"
    
    // cashplus url
    static public let PAY_CASHPLUS_URL: String = BASE_URL + "/api/cashplus/init"
  
}
