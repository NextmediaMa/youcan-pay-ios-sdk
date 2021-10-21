import XCTest
@testable import YouCanPay
    
final class YouCanPayTests: XCTestCase {
    
    let pubKey: String = "pub_40526e71"
    let token: String = "e9f526ca-16fc-4432"
    
    var ycPay: YCPay!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        // init YCPay class
        ycPay = YCPay(pubKey: pubKey, token: token)
        // activate sandbox mode
        ycPay.setSandboxMode(true)
    }

    override func tearDownWithError() throws {
      ycPay = nil
      try super.tearDownWithError()
    }
  
    // testing payment with a none 3DS card -> Succeeded
    func testPayEndpointNone3dsSucceeded() throws {
        try XCTSkipUnless(
            YCPNetworkMonitor.isReachable(),
            "Network connectivity needed for this test."
        )
        
        // given
        let cardInfo = YCPCardInformation(cardHolderName: "a name here", cardNumber: "4242424242424242", expireDate: "10/24", cvv: "112")
        let promise = expectation(description: "Payment successfully made")
        var succeeded: Bool?
        var fakeResult = YCPResult (true)
        fakeResult.is3DS = false
        
        // when
        try ycPay.pay(cardInfo, { (result) in
            if !fakeResult.is3DS && fakeResult.success {
                succeeded = true
            }else{
                succeeded = false
            }
            promise.fulfill()
        })

        wait(for: [promise], timeout: 5)
        
        // then
        XCTAssertEqual(succeeded, true)
    }
    
    // testing payment with a none 3DS card -> Failed
    func testPayEndpointNone3dsFailed() throws {
        try XCTSkipUnless(
            YCPNetworkMonitor.isReachable(),
            "Network connectivity needed for this test."
        )
        
        // given
        let cardInfo = YCPCardInformation(cardHolderName: "a name here", cardNumber: "4242424242424242", expireDate: "10/24", cvv: "112")
        let promise = expectation(description: "Payment successfully made")
        var succeeded: Bool?
        let fakeResult = YCPResult (false, "Failed for this reason", false)
        
        // when
        try ycPay.pay(cardInfo, { (result) in
            if !fakeResult.is3DS && fakeResult.success {
                succeeded = true
            }else{
                succeeded = false
            }
            promise.fulfill()
        })

        wait(for: [promise], timeout: 5)
        
        // then
        XCTAssertEqual(succeeded, false)
    }
    
    // testing payment with a 3DS card -> Succeeded
    func testPayEndpoint3dsSucceeded() throws {
        try XCTSkipUnless(
            YCPNetworkMonitor.isReachable(),
            "Network connectivity needed for this test."
        )
        
        // given
        let cardInfo = YCPCardInformation(cardHolderName: "a name here", cardNumber: "4242424242424242", expireDate: "10/24", cvv: "112")
        let promise = expectation(description: "Payment successfully made")
        var succeeded: Bool?
        var fakeResult = YCPResult (true)
        fakeResult.is3DS = true
        
        // when
        try ycPay.pay(cardInfo, { (result) in
            if fakeResult.is3DS && fakeResult.success {
                succeeded = true
            }else{
                succeeded = false
            }
            promise.fulfill()
        })

        wait(for: [promise], timeout: 5)
        
        // then
        XCTAssertEqual(succeeded, true)
    }
    
    // testing payment with a 3DS card -> Failed
    func testPayEndpoint3dsFailed() throws {
        try XCTSkipUnless(
            YCPNetworkMonitor.isReachable(),
            "Network connectivity needed for this test."
        )
        
        // given
        let cardInfo = YCPCardInformation(cardHolderName: "a name here", cardNumber: "4242424242424242", expireDate: "10/24", cvv: "112")
        let promise = expectation(description: "Payment successfully made")
        var succeeded: Bool?
        let fakeResult = YCPResult (false, "Failed with this reason", true)
        
        // when
        try ycPay.pay(cardInfo, { (result) in
            if fakeResult.is3DS && fakeResult.success {
                succeeded = true
            }else{
                succeeded = false
            }
            promise.fulfill()
        })

        wait(for: [promise], timeout: 5)
        
        // then
        XCTAssertEqual(succeeded, false)
    }
}
