import Foundation

public struct YCPAccountConfig {
    public var acceptsCreditCards: Bool = false
    public var acceptsCashPlus: Bool = false
    public var cashPlusTransactionEnabled: Bool = false
    
    init() {
    }
    
    public init(acceptsCreditCards: Bool, acceptsCashPlus: Bool, cashPlusTransactionEnabled: Bool) {
        self.acceptsCreditCards = acceptsCreditCards
        self.acceptsCashPlus = acceptsCashPlus
        self.cashPlusTransactionEnabled = cashPlusTransactionEnabled
    }
}
