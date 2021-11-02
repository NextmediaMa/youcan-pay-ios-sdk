import Foundation

protocol YCPHttpAdapter {    
    func request(_ method: String, _ endpoint: String, _ params: [String : Any], _ headers: YCParameters?, _ completion: @escaping (YCPHttpResponse) -> Void)
}
