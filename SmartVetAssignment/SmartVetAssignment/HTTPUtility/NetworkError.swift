//
//  NetworkError.swift
//  SmartVetAssignment
//
//  Created by NWagh on 05/11/22.
//

import Foundation

public struct NetworkError : Error {
    let reason: String?
    let httpStatusCode: Int?
    
    init(errorMessage message: String, forStatusCode statusCode: Int) {
        self.httpStatusCode = statusCode
        self.reason = message
    }
}
