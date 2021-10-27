import XCTest
@testable import YouCanPay

final class YouCanPayTests: XCTestCase {
    
    let pubKey: String = "pub_40526e71"
    let token: String = "e9f526ca-16fc-4432"
    
    var ycPay: YCPay!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        //init YCPay class
        ycPay = YCPay(pubKey: pubKey, locale: "en")
        //activate sandbox mode
        ycPay.setSandboxMode(true)
    }
    
    override func tearDownWithError() throws {
        ycPay = nil
        try super.tearDownWithError()
    }
    
    func testValidatingCard() {
        let promise = expectation(description: "date correct")
        let cardInfo = YCPCardInformation(cardHolderName: "anass", cardNumber: "5487477802835935", expiryDate: "10/23", cvv: "555")
        do{
        try YCPCardValidation.validate(cardInfo)
            promise.fulfill()
        }catch{
            print("error: \(error.localizedDescription)")
        }
        
        wait(for: [promise], timeout: 2)
    }
    
    func testLocale() {
        let string = YCPLocalizable.get("An error occurred while processing the payment.")
        
        XCTAssertEqual(string, "An error occurred while processing the payment.")
    }
    
    // testing payment with a none 3DS card -> Succeeded
    func testPayEndpointNone3dsSucceeded() throws {
        // given
        let cardInfo = YCPCardInformation(cardHolderName: "a name here", cardNumber: "4242424242424242", expiryDate: "10/24", cvv: "112")
        let promise = expectation(description: "Payment successfully made")
        var succeeded = false
        
        // when
        try ycPay.pay(token,
                      cardInfo,
                      UIViewController(),
                      {(onSuccess) in
                        succeeded = true
                        promise.fulfill()
                      },
                      {(onFailure) in
                        succeeded = false
                      })
        
        wait(for: [promise], timeout: 5)
        
        // then
        XCTAssertEqual(succeeded, true)
    }
}
