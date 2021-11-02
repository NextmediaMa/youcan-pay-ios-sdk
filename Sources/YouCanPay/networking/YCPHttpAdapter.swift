import Foundation

extension YCPHttpAdapter {
    public func get(_ endpoint: String, _ params: [String : Any], _ headers: YCParameters?, _ completion: @escaping (YCPHttpResponse) -> Void) {
        return request("GET", endpoint, params, headers, completion)
    }
    
    public func post(_ endpoint: String, _ params: [String : Any], _ headers: YCParameters?, _ completion: @escaping (YCPHttpResponse) -> Void) {
        return request("POST", endpoint, params, headers, completion)
    }
}
