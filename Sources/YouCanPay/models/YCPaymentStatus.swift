import Foundation

///The values defined in an enumeration (such as canceled, pending, success, and other) are its enumeration cases. You use the case keyword to introduce new enumeration cases.
public enum YCPaymentStatus : Int, Codable {
    case canceled = -1
    case pending = 0
    case success = 1
}
