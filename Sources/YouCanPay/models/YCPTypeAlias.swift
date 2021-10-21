import Foundation

/// Params type key value as string
public typealias YCParameters = [String : String]

/// A block called with a connection YCPCallbackResult or an NSError
public typealias YCPaymentCallbackCompletionBlock = (YCPCallbackResult?, NSError?) -> Void
