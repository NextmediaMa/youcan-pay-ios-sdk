import Foundation
#if !os(tvOS)
import UIKit
import WebKit
#endif

@IBDesignable
open class YCPWebview: WKWebView {
    
    var callbackUrl: String = ""
    
    /// loading 3DS page html in YCPwebview
    func loadHtmlString(_ result: YCPResult) {
        configWebview()
        self.callbackUrl = result.threeDS.returnUrl
        
        if result.isSandboxModeActived {
            self.loadHTMLString(loadSandbox3dsPage(result), baseURL: nil)
            return
        }
        
        let link = URL(string:"\(result.threeDS.redirectUrl)")!
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
    
    func loadSandbox3dsPage(_ result: YCPResult) -> String {
        let filePath = Bundle.module.path(forResource: "sandbox_3ds_page", ofType: "html")
        let contentData = FileManager.default.contents(atPath: filePath!)
        if let pageString = NSString(data: contentData!, encoding: String.Encoding.utf8.rawValue) as String? {
            
            var replacedHtmlContent = pageString.replacingOccurrences(of: "u@%", with: "\(result.threeDS.returnUrl)")
            replacedHtmlContent = replacedHtmlContent.replacingOccurrences(of: "t@%", with: "\(result.threeDS.transactionId)")
            
            return replacedHtmlContent
        }
        
        return ""
    }
    
    /// checking if the payment is succeded or not via the callback url
    func checkCallback(returnUrl: String) -> YCPResult {
        if returnUrl.contains(callbackUrl) {
            self.isHidden = true
            let params = getParamsFromUrl(returnUrl)
            
            if params["is_success"] == "1" {
                var result = YCPResult(true)
                result.threeDS.transactionId = params["transaction_id"] ?? ""
                result.callbackInvoked = true
                
                return result
            }
            
            var result = YCPResult(false,params["message"] ?? "")
            result.callbackInvoked = true
            
            return result
        }
        
        return YCPResult(false)
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
