import XCTest
@testable import YouCanPay

class PayEndpointTest: XCTestCase {
    // testing payment with a none 3DS card -> Succeeded
    func testPayEndpointNone3dsSucceeded() throws {
        // given
        let jsonResponse = """
        {
            "success": true,
            "message": "The payment was processed successfully",
            "transaction_id": "123456"
        }
        """
        let httpResponse = YCPHttpResponse(success: true, statusCode: 200, response: jsonResponse)
        let fakeHttpAdapter = FakeAPIAdapter(httpResponse: httpResponse)
        let payService = YCPayService(httpAdapter: fakeHttpAdapter)
        let params = ["":""] as [String : Any]
        let promise = expectation(description: "Payment successfully made")
        var expectedTransactionId = ""
        
        // when
        payService.post(params, true, UIViewController(), { (transactionId) in
            // your code
            expectedTransactionId = transactionId
            promise.fulfill()
        }, { (error) in
            // your code
            promise.fulfill()
        })
        wait(for: [promise], timeout: 5)
        
        // then
        XCTAssertEqual(expectedTransactionId, "123456")
    }
    
    // testing payment with a none 3DS card -> Failed
    func testPayEndpointNone3dsFailed() throws {
        // given
        let jsonResponse = """
        {
            "success": false,
            "message": "The payment was failed",
            "transaction_id": null
        }
        """
        let httpResponse = YCPHttpResponse(success: true, statusCode: 500, response: jsonResponse)
        let fakeHttpAdapter = FakeAPIAdapter(httpResponse: httpResponse)
        let payService = YCPayService(httpAdapter: fakeHttpAdapter)
        let params = ["":""] as [String : Any]
        let promise = expectation(description: "Payment failed")
        var errorMsg = ""
        
        // when
        payService.post(params, true, UIViewController(), { (transactionId) in
            // your code
            promise.fulfill()
        }, { (error) in
            // your code
            errorMsg = error
            promise.fulfill()
        })
        wait(for: [promise], timeout: 5)
        
        // then
        XCTAssertEqual(errorMsg, "The payment was failed")
    }
}
