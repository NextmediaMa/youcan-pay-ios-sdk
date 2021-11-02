<p align="center"><a href="https://pay.youcan.shop" target="_blank"><img src="https://pay.youcan.shop/images/ycpay-logo.svg" width="400"></a></p>


YouCanPay iOS SDK makes it quick and easy to build an excellent payment experience in your iOS app with [YouCan Pay API](https://pay.youcan.shop/docs).

## Requirements :

The YouCanPay iOS SDK requires Xcode 11 or later and is compatible with apps targeting iOS 10 or above. We support Catalyst on macOS 10.12 or later.

## Basic Usage :

####  Server-side 

This integration requires endpoints on your server that talk to the YouCanPay API. Use our official libraries for access to the YouCanPay API from your server:  the following steps in our [Documentation](https://pay.youcan.shop/docs) will guide you through.

#### Installation 

- Swift Package Manager 
```bash
dependencies: [
    .package(url: "https://github.com/NextmediaMa/youcan-pay-ios-sdk", .upToNextMajor(from: "0.0.1"))
]
```

```swift
import YouCanPay

class ViewController: UIViewController {
    var ycPay: YCPay?

    // called to initialize your payment
    func initializePayment() {
        // call your tokenizer endpoint to get token and your pubkey
        
        // initialize YouCan Pay
        self.ycPay = YCPay(pubKey: "YOUR PUBKEY")

        // setting the sandbox mode
        self.ycPay?.setSandboxMode(true)
    }
    
    // start the payment
    func pay() {
        do{
            // set your card information
            cardInfo = YCPCardInformation(cardHolderName: "NAME", cardNumber: "XXXXXXXXXXXXXXXX", expiryDate: "XX/XX", cvv: "XXX")
            
            // call pay
            try self.ycPay?.pay("YOUR TOKEN",
                                cardInfo!,
                                self,
                                successCallback,
                                errorCallback)
        }catch{
            print("error: \(error)")
        }
    }
    
    func successCallback(transactionId: String) {
        // your code here
    }
    
    func errorCallback(errorMessage: String) {
        // your code here
    }
}
```

## Example :

Here's a [Sample](https://github.com/NextmediaMa/youcan-pay-ios-integration-example) showing how to implement YouCan Pay ios sdk.

Happy coding :slightly_smiling_face:
