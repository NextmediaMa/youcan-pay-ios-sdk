<p align="center"><a href="https://pay.youcan.shop" target="_blank"><img src="https://pay.youcan.shop/images/ycpay-logo.svg" width="400"></a></p>


YouCanPay iOS SDK makes it quick and easy to build an excellent payment experience in your iOS app with [YouCan Pay API](https://pay.youcan.shop/docs).

## Requirements :

The YouCanPay iOS SDK requires Xcode 11 or later and is compatible with apps targeting iOS 10 or above. We support Catalyst on macOS 10.12 or later.

## Basic Usage

###  Server-side 



integration requires endpoints on your server that talk to the YouCanPay API. Use our official libraries for access to the YouCanPay API from your server:  the following steps in our [Documentation](https://pay.youcan.shop/docs) will guide you through.

### Install the YouCan Pay SDK :

### Swift Package Manager
The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

Once you have your Swift package set up, adding YouCanPay SDK as a dependency is as easy as adding it to the dependencies value of your Package.swift.

dependencies: [
    .package(url: "https://github.com/NextmediaMa/ycpayment-ios-sdk.git")
]

### Set up Payment :

 #### Initials YCPay
 The first step is to initialize YouCanPay SDK by creating an instance using the following parameters : ```pub_key``` and ```locale``` as localizable the default language is en 
```swift
import YouCanPay

/// Initialize YouCanPay SDK
/// - Parameter locale: is an optional parameter it can accept (en, ar, fr) to recieve messages with the localization provided it the initialization
let ycPay = YCPay(pubKey: "YOUR PUB KEY", locale: “en”)  
 ```
 
##### pub_key 
The seller's YouCanPay account public key. This lets us know who is receiving the payment.

#### Load supported payment methods
 After we initials ```ycPay``` we can load the supprted payment methods using: 
 ```swift
 import YouCanPay
 
    ycPay.isLoading.observe = { isLoaded in      
      if ycPay.ycpAccountConfig.acceptsCreditCards {
        // Credit cards payment method is available
      }
      
      if ycPay.ycpAccountConfig.acceptsCashPlus {
        // CashPlus is available
      }
    }
```

### Start Payment Using Credit Card:
When you get ``` ycPay.ycpAccountConfig.acceptsCreditCards == true``` it means that Credit Card payment methodis allowed.

#### Initials Card Informtaion
```swift
let cardInfo = YCPCardInformation(cardHolderName: "NAME", cardNumber: "XXXXXXXXXXXXXXXX", expiryDate: "XX/XX", cvv: "XXX")
 ```
 
#### Proceed payment using Credit Card:
You can use ```ycPay.payWithCreditCard```  to proceed your payment use as parametrs the ```token_id``` it can be generated from your server side and received through an endpoint to the mobile application, to generate a token please refer to the [Tokenization section](https://youcanpay.com/docs#tokenization).
```swift
import YouCanPay

private func pay() {
    do{
      // start loader
      
      // initialize 
      let cardInfo = YCPCardInformation(cardHolderName: "NAME", cardNumber: "XXXXXXXXXXXXXXXX", expiryDate: "XX/XX", cvv: "XXX")
       
      try self.ycPay.payWithCreditCard("token_id",
                       cardInfo!,
                       self,
                       successCallback,
                       errorCallback)
    }catch{
      // show error
      // stop loader
    }
  }
   
   // onSuccess callback
  func successCallback(transactionId: String) {
    // a transaction id is retrieved  
    // stop loader
  }
   
   // onFailure callback
  func errorCallback(errorMessage: String) {
    // a error message is retrieved 
    // stop loader
  }
```
Once the onSuccess callback invoked it means that the transaction is processeded successfully, a transaction ID will be recieved as a parameter that you can submit with your order details. Similarly, onFailure is called when an error is occurred during the payment, and you get the error message as a parameter to show to customer.

### Start Payment Using CashPlus:
If you you get ```ycPay.ycpAccountConfig.acceptsCashPlus == true``` that's mean that you have CashPlus as a payment method


#### Proceed payment using CashPlus:
You can use ```ycPay.payWithCashPlus``` to proceed your payment use as parametrs the ```token_id``` it can be generated from your server side and received through an endpoint to the mobile application, to generate a token please refer to the [Tokenization section](https://youcanpay.com/docs#tokenization).

```swift
import YouCanPay

private func pay() {
    do{
      // start loader
      
      try self.ycPay.payWithCashPlus("token_id",
                       successCallback,
                       errorCallback)
    }catch{
      // show error
      // stop loader
    }
  }
   
   // onSuccess callback
  func successCallback(transactionId: String) {
    // a transaction id is retrieved  
    // stop loader
  }
   
   // onFailure callback
  func errorCallback(errorMessage: String) {
    // a error message is retrieved 
    // stop loader
  }
```

### Sandbox
YouCan Pay [Sandbox](https://pay.youcan.shop/docs#sandbox) offers an easy way for developers to test YouCan Pay in their test environment.

```swift
// setting the sandbox mode
ycPay.setSandboxMode(false)
```

Happy coding :slightly_smiling_face:
