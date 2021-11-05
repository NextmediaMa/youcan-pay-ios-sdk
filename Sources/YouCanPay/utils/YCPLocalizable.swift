import Foundation

class YCPLocalizable {
    private static let defaultLocale: String = "en"
    private static var currentLocale: String = "en"
    private static let supportedLocales: [String] = ["en", "fr", "ar"]
    
    class func setCurrentLocale(locale: String) {
        if supportedLocales.contains(locale) {
            currentLocale = locale
            return
        }
        
        currentLocale = defaultLocale
    }
    
    class func getCurrentLocale() -> String {
        return currentLocale
    }
    
    class func getDefaultLocale() -> String {
        return defaultLocale
    }
    
    class func get(_ key: String) -> String {
        let path = Bundle.module.path(forResource: currentLocale, ofType: "lproj")
        let bundle = Bundle(path: path!)
        if let value = bundle?.localizedString(forKey: key, value: key, table: nil) {
            return value
        }
        
        return key
    }
}
