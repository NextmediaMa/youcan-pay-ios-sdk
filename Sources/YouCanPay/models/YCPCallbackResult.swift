import Foundation

///Data Model to handle the YCPCallbackResult data
public struct YCPCallbackResult : Codable {
    public var id: String  = ""
    public var orderId: String  = ""
    public var amount: Double = 0
    public var currency: String  = ""
    public var status: Int = 0
    public var createdAt: String  = ""

    init() {
    }
    
    init(id: String, orderId: String, amount: Double, currency: String, status: Int, createdAt: String) {
        self.id = id
        self.orderId = orderId
        self.amount = amount
        self.currency = currency
        self.status = status
        self.createdAt = createdAt
    }
}
