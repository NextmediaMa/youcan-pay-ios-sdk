import Foundation

class YCPInvalidArgumentException: NSError {
    private var responseStatus: Int = 53
    
    init(message: String) {
        super.init(domain: message, code: self.responseStatus, userInfo: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getResponseStatus() -> Int {
        return self.responseStatus
    }
}
