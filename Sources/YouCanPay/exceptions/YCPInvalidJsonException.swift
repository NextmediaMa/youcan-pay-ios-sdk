import Foundation

class YCPInvalidJsonException: NSError {
    private var responseStatus: Int = 51
    private var responseBody: [String : Any]?
    private var message: String = "Error occurred while decoding json"
    
    init(responseStatus: Int = 51, message: String = "", responseBody: [String : Any]? = nil) {
        self.responseStatus = responseStatus
        self.message = message.count > 0 ? message : self.message
        self.responseBody = responseBody
        
        super.init(domain: self.message, code: self.responseStatus, userInfo: self.responseBody)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getMessage() -> String {
        return self.message;
    }
    
    func getResponseBody() -> [String : Any]? {
        return self.responseBody;
    }
    
    func getResponseStatus() -> Int {
        return self.responseStatus
    }
}
