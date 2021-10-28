import Foundation
#if !os(tvOS)
import UIKit
import WebKit
#endif

class YCPViewController: UIViewController, WKNavigationDelegate {
    
    var result: YCPResult
    var headerView: UIView!
    let ycpWebview = YCPWebview()
    let onSuccess: (String) -> Void
    let onFailure: (String) -> Void
    
    init(_ result: YCPResult,
         _ onSuccess: @escaping (String) -> Void,
         _ onFailure: @escaping (String) -> Void)
    {
        self.result = result
        self.onSuccess = onSuccess
        self.onFailure = onFailure
        super.init(nibName: nil, bundle: nil)        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        self.view = createView()
        self.view.backgroundColor = .white
        self.view.addSubview(createHeader())
        
        createWebview()
    }
    
    func createView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
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
    
    func createWebview() {
        self.ycpWebview.navigationDelegate = self
        self.ycpWebview.loadHtmlString(self.result)
        self.ycpWebview.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.ycpWebview)
        
        NSLayoutConstraint.activate([
            self.ycpWebview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.ycpWebview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.ycpWebview.topAnchor.constraint(equalTo: self.headerView.bottomAnchor),
            self.ycpWebview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    @objc func dismissVC(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.onFailure(YCPLocalizable.get("Payment canceled"))
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let callbackResult = self.ycpWebview.checkCallback(returnUrl: "\(webView.url!)")
        
        if callbackResult.callbackInvoked {
            if callbackResult.success {
                self.onSuccess(callbackResult.threeDS.transactionId)
            } else {
                self.onFailure(callbackResult.message)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
}
