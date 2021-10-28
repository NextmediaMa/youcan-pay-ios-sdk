import Foundation

class YCPLocalizable {
    class func get(_ key: String) -> String {
        let path = Bundle.module.path(forResource: YCPConfigs.CURRENT_LOCALE, ofType: "lproj")
        let bundle = Bundle(path: path!)
        if let value = bundle?.localizedString(forKey: key, value: key, table: nil) {
            return value
        }
        
        return key
    }
}

#if !SPM
extension Bundle {
  static var module:Bundle { Bundle(identifier: "YouCanPay")! }
}
#endif
