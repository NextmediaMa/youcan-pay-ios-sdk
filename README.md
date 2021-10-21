<p align="center"><a href="https://pay.youcan.shop" target="_blank"><img src="https://pay.youcan.shop/images/ycpay-logo.svg" width="400"></a></p>


YouCanPay iOS SDK makes it quick and easy to build an excellent payment experience in your iOS app with [YouCan Pay API](https://pay.youcan.shop/docs).

## Requirements :

The YouCanPay iOS SDK requires Xcode 11 or later and is compatible with apps targeting iOS 10 or above. We support Catalyst on macOS 10.12 or later.

## Basic Usage

####  Server-side 

This integration requires endpoints on your server that talk to the YouCanPay API. Use our official libraries for access to the YouCanPay API from your server:  the following steps in our [Documentation](https://pay.youcan.shop/docs) will guide you through.

#### Add the endpoints :

___Tokenizer endpoint :___ allows you to generate a token as well as a public key on the backend side in order to use it to communicate with YouCanPay API

___Callback endpoint :___  allows you to retrieve the payment status


#### Installation using Cocoapods :

```bash
pod install YouCanPay
```

```swift
import YouCanPay

// generate a token for a new payment
let ycPay = YCPay(pubKey: "YOUR PUB KEY", token: "YOUR TOKEN")
ycPay.paymentCallback.create(callbackUrl: "YOUR CALLBACK URL", transactionId: "YOUR TRANSACTION ID", headerParams: ["Authorization": "Bearer YOUR TOKEN IF NEEDED"])

// proceed with the payment
try YCPay.pay(cardInfo, {(result) in
    if result.success {
        paymentCallbackHandler()
        return
    }

    if result.is3DS {
        self.webView.loadHtmlString(result)
    }
})
```

## Handling Events

A didFinish delegate must be added for your YCPWebview in order to catch the response and handle it.

```swift
import YouCanPay
 
 // didFinish delegate
 func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
     self.paymentCallbackHandler()
 }
 
 // called to handle payment status 
 func paymentCallbackHandler(){
     do{
         try YCPay.paymentCallback.call(onSuccess: {(status) in
             switch status.rawValue {
             case YCPaymentStatus.success.rawValue:
                 print("Payment succeeded")
             case YCPaymentStatus.canceled.rawValue:
                 print("Payment canceled")
             case YCPaymentStatus.pending.rawValue:
                 print("Payment is pending")
             default:
                print("\(status)")
             }
         }, onFailure: {(error) in
             print("\(error)")
         })
     }catch{
        print("\(error)")
     }
 }
```






