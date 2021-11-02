import Foundation

class YCPHttpResponse {
    private var success: Bool
    private var statusCode: Int?
    private var response: String?
    
    init(success: Bool, statusCode: Int?, response: String?) {
        self.success = success
        self.statusCode = statusCode
        self.response = response
    }
    
    public func getStatusCode() -> Int? {
        return self.statusCode
    }
    
    public func getResponse() -> String? {
        return self.response
    }
    
    public func isSuccess() -> Bool {
        return self.success
    }
    
    
}
