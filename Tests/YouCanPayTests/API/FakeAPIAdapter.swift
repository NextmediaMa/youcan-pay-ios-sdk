import Foundation
@testable import YouCanPay

class FakeAPIAdapter: YCPHttpAdapter {
    var httpResponse: YCPHttpResponse
    
    init(httpResponse: YCPHttpResponse) {
        self.httpResponse = httpResponse
    }
    
    func request(_ method: String, _ endpoint: String, _ params: [String : Any], _ headers: YCParameters?, _ completion: @escaping (YCPHttpResponse) -> Void) {
        completion(self.httpResponse)
    }
}
