import Foundation
import Alamofire

/// called to send http requests with post method 
public class YCPHttpRequest: NSObject {
    class func post(url: String, params: [String : Any], headerParams: YCParameters? = nil) -> DataRequest {
        var headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        if let parameters = headerParams {
            for (key, value) in parameters {
                headers.add(name: key, value: value)
            }
        }
        
        return AF.request(url, method: .post,
                          parameters: params,
                          encoding: URLEncoding.default,
                          headers: headers)
    }
}
