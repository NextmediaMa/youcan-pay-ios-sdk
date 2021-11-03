import Foundation
#if !os(tvOS)
import UIKit
import WebKit
#endif

class YCPViewController: UIViewController, WKNavigationDelegate {
    
    var response: YCPResponse3ds
    var headerView: UIView!
    var callbackUrlInvoked = false
    let ycpWebview = YCPWebview()
    let onSuccess: (String) -> Void
    let onFailure: (String) -> Void
    
    /// constructor
    init(_ response: YCPResponse3ds,
         _ onSuccess: @escaping (String) -> Void,
         _ onFailure: @escaping (String) -> Void)
    {
        self.response = response
        self.onSuccess = onSuccess
        self.onFailure = onFailure
        super.init(nibName: nil, bundle: nil)        
    }
    
    /// default constructor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// load view
    override func loadView() {
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        self.view = createView()
        self.view.backgroundColor = .white
        self.view.addSubview(createHeader())
        
        createWebview()
    }
    
    /// init view
    func createView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    // create header
    func createHeader() -> UIView {
        let screenSize: CGRect = UIScreen.main.bounds
        self.headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 70))
        self.headerView.backgroundColor = .white
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 70))
        let image = UIImage(named: "close_btn", in: .module, compatibleWith: nil)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(dismissVC(_:)), for: .touchUpInside)
        self.headerView.addSubview(button)
        
        return headerView
    }
    
    /// create webview
    func createWebview() {
        self.ycpWebview.navigationDelegate = self
        self.ycpWebview.scrollView.delegate = self
        self.ycpWebview.allowsBackForwardNavigationGestures = true
        self.ycpWebview.loadHtmlString(self.response)
        self.ycpWebview.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.ycpWebview)
        
        NSLayoutConstraint.activate([
            self.ycpWebview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.ycpWebview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.ycpWebview.topAnchor.constraint(equalTo: self.headerView.bottomAnchor),
            self.ycpWebview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    /// call to action for dismiss
    @objc func dismissVC(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// delegate to catch urls
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.request.url != nil {
            let callbackResult = self.ycpWebview.checkCallback(returnUrl: "\(navigationAction.request.url!.absoluteString)")
            
            if callbackResult.callbackInvoked {
                if callbackResult.success {
                    self.onSuccess(callbackResult.transactionId)
                } else {
                    self.onFailure(callbackResult.message)
                }
                self.callbackUrlInvoked = true
                self.dismiss(animated: true, completion: nil)
                decisionHandler(.cancel)
                
                return
            }
        }
        
        decisionHandler(.allow)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !self.callbackUrlInvoked {
            self.onFailure(YCPLocalizable.get("Payment canceled"))
        }
    }
}

extension YCPViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}
