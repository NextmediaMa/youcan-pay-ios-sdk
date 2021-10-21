import Foundation
import WebKit
import UIKit

@IBDesignable
open class YCPWebview: WKWebView {
    
    public var callBackUrl : String = ""
    
    /// loading 3DS page html in YCPwebview
    public func loadHtmlString(_ result : YCPResult) {
        configWebview()
        
        if result.sandboxModeActived {
            self.loadHTMLString(result.threeDsPage, baseURL: nil)
        }else{
            let link = URL(string:"\(result.threeDsPage)")!
            let request = URLRequest(url: link)
            self.load(request)
        }
        
        self.callBackUrl = result.callBackUrl
    }
    
    /// configure the wkwebview to be responsive with mobile
    func configWebview(){
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
    public func checkCallback(redirectUrl : String) -> YCPResult {
        if redirectUrl.contains(callBackUrl) {
            let params = getParamsFromUrl(redirectUrl)
            if params["is_success"] == "1" {
                var result = YCPResult(true)
                result.transactionId = params["transaction_id"] ?? ""
                result.callBackInvoked = true
                self.isHidden = true
                return result
            }else{
                var result = YCPResult(false,params["message"] ?? "")
                result.callBackInvoked = true
                self.isHidden = true
                return result
            }
        }
        
        return YCPResult(false)
    }
    
    /// called to fetch params from callback url
    func getParamsFromUrl(_ url : String) -> YCParameters{
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
            let value = tmps[1]
            
            parametres[String(key)] = String(value)
        }
         
        return parametres
    }
    
}

