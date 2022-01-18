//
//  File.swift
//  
//
//  Created by Anass ALOUANE on 17/1/2022.
//

import Foundation

class YCPResponseCashplus: YCPResponse {
    var transactionId: String = ""
    var success: Bool = false
    var message: String = ""
    var token: String = ""
    
    init() {
    }
    
    init(success: Bool, message: String = "", transactionId: String = "", token: String = "") {
        self.success = success
        self.message = message
        self.transactionId = transactionId
        self.token = token
    }
}
