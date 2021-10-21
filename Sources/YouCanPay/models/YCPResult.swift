import Foundation

///Data Model to handle the YCPResult data
public struct YCPResult: Codable {
    public var success: Bool = false
    public var message: String = ""
    public var is3DS: Bool = false
    public var threeDsPage: String = ""
    public var transactionId: String = ""
    public var callBackUrl: String = ""
    public var callBackInvoked: Bool = false
    public var sandboxModeActived: Bool = false
    
    public init(_ success: Bool, _ message: String = "", _ is3DS: Bool = false) {
        self.success = success
        self.message = message
        self.is3DS = is3DS
    }
}
