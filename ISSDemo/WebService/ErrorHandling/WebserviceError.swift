//
//  WebserviceError.swift
//  ISSDemo
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import UIKit

class WebserviceError: NSError {

    // MARK: - Properties
    
    var type: ErrorType = .notSet
    
    // MARK: - Enums
    
    enum ErrorType {
        case invalidUrl(url: String),
        invalidResponseCode(code: Int),
        invalidData(data: Data?),
        decodingError(data: Data),
        notSet
    }
    
    // MARK: - Initializers
    
    /// Initializes the WebserviceError with a specific error type.
    ///
    /// - Parameters:
    ///   - type: the ErrorType of this error.
    convenience init(type: ErrorType) {
        self.init(domain: "Webservice", code: 0, userInfo: nil)
        self.type = type
    }
    
    // MARK: - Methods
    
    /// Returns the error message based on the error type.
    ///
    /// - Returns: the error message of the error
    func errorMessage() -> String {
        switch type {
        case .invalidUrl(let url):
            return "Error: invalid service url: \(url)."
        case .invalidResponseCode(let code):
            return "Error: invalid response code: \(code)."
        case .invalidData(let data):
            return "Error: invalid response data: \(String(describing: data?.description))."
        case .decodingError(let data):
            return "Error: failed to decode data: \(data.description)."
        case .notSet:
            return "Error: unknown error."
        }
    }
    
}
