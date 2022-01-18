import Foundation

public struct YCPAccountConfig {
    var acceptsCreditCards: Bool = false
    var acceptsCashPlus: Bool = false
    var cashPlusTransactionEnabled: Bool = false
    
    init() {
    }
    
    public init(acceptsCreditCards: Bool, acceptsCashPlus: Bool, cashPlusTransactionEnabled: Bool) {
        self.acceptsCreditCards = acceptsCreditCards
        self.acceptsCashPlus = acceptsCashPlus
        self.cashPlusTransactionEnabled = cashPlusTransactionEnabled
    }
}
