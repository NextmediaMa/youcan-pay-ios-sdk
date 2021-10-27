import Foundation

///Data Model to handle the YCPResult data
struct YCPResult: Codable {
    var success: Bool = false
    var message: String = ""
    var threeDS = YCPThreeDSecure()
    var callbackInvoked: Bool = false
    var isSandboxModeActived: Bool = false
    
    init(_ success: Bool, _ message: String = "") {
        self.success = success
        self.message = message
    }
}
