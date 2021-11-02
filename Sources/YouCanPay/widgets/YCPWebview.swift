import Foundation
#if !os(tvOS)
import UIKit
import WebKit
#endif

@IBDesignable
open class YCPWebview: WKWebView {
    
    var callbackUrl: String = ""
    
    /// loading 3DS page html in YCPwebview
    func loadHtmlString(_ response: YCPResponse3ds) {
        configWebview()
        self.callbackUrl = response.returnUrl
        
        let link = URL(string:"\(response.redirectUrl)")!
        let request = URLRequest(url: link)
        self.load(request)
    }
    
    /// configure the wkwebview to be responsive with mobile
    func configWebview() {
        self.isHidden = false
        self.allowsBackForwardNavigationGestures = true
        
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" +
            "head.appendChild(meta);"
        
        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController: WKUserContentController = WKUserContentController()
        let conf = WKWebViewConfiguration()
        conf.userContentController = userContentController
        userContentController.addUserScript(script)
        
        self.configuration.userContentController.addUserScript(script)
    }
    
    /// checking if the payment is succeded or not via the callback url
    func checkCallback(returnUrl: String) -> YCPResponseSale {
        if returnUrl.contains(callbackUrl) {
            self.isHidden = true
            let params = getParamsFromUrl(returnUrl)
            
            if params["success"] == "1" {
                let result = YCPResponseSale(success: true, transactionId: params["transaction_id"] ?? "")
                result.callbackInvoked = true
                
                return result
            }
            
            let result = YCPResponseSale(success: false, message: params["message"] ?? "")
            result.callbackInvoked = true
            
            return result
        }
        
        return YCPResponseSale(success: false)
    }
    
    /// called to fetch params from callback url
    func getParamsFromUrl(_ url: String) -> YCParameters {
        var parametres = YCParameters()
        let pos = (url.range(of: "?", options: .forcedOrdering)?.lowerBound)
        
        if pos == nil {
            return parametres
        }
        
        var substring = url[(pos!)...]
        let index = substring.index(substring.startIndex, offsetBy: 1)
        substring = substring[index...]
        
        let paramsArr = substring.split(separator: "&")
        
        for i in 0..<paramsArr.count{
            let tmps = paramsArr[i].split(separator: "=")
            let key = tmps[0]
            var value : Substring = ""
            if tmps.count > 1 {
                value = tmps[1]
            }
            
            parametres[String(key)] = String(value)
        }
        
        return parametres
    }
}
