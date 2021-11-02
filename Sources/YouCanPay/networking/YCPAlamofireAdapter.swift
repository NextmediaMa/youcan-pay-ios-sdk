import Foundation
import Alamofire

public class YCPAlamofireAdapter: YCPHttpAdapter {    
    func request(_ method: String,
                 _ endpoint: String,
                 _ params: [String : Any],
                 _ headers: YCParameters?,
                 _ completion: @escaping (YCPHttpResponse) -> Void)
    {
        var header: HTTPHeaders = [
            "Accept": "application/json",
            "X-Preferred-Locale": "\(YCPConfigs.CURRENT_LOCALE)",
        ]
        
        if let parameters = headers {
            for (key, value) in parameters {
                header.add(name: key, value: value)
            }
        }
        
        var httpMethod = HTTPMethod.post
        if method == "GET" {
            httpMethod = HTTPMethod.get
        }
                
        AF.request(endpoint,
                   method: httpMethod,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: header).responseJSON { (responseData) -> Void in
                    switch responseData.result {
                    case .success(_):
                        if let data = responseData.data, let utf8Text = String(data: data, encoding: .utf8) {
                            completion(YCPHttpResponse(success: true,
                                                       statusCode: responseData.response?.statusCode,
                                                       response: utf8Text))
                        }
                    case let .failure(error):
                        completion(YCPHttpResponse(success: false,
                                                   statusCode: responseData.response?.statusCode,
                                                   response: error.localizedDescription))
                    }
                   }
    }
}
