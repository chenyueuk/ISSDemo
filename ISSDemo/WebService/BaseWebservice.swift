//
//  BaseWebservice.swift
//  ISSDemo
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import Alamofire

class BaseWebservice {
    
    // MARK: - Methods
    
    /// Https request call expecting data response.
    /// Invalid URL, HttpResponse error, invalid http response code, invalid data are handled in this default caller
    ///
    /// - Parameters:
    ///   - queue: optional DispatchQueue where the request executes in
    ///   - urlString: the string value for https call url.
    ///   - method: HTTPMethod (GET, POST, DELTE etc.).
    ///   - onCompletion: completion handler that has optional response error and optional response data as parameter.
    final func dataRequest(queue: DispatchQueue? = nil,
                           _ urlString: String,
                           method: HTTPMethod,
                           parameters: Parameters? = nil,
                           headers: HTTPHeaders? = nil,
                           _ onCompletion: @escaping(WebserviceError?, Data?) -> Void) {
        
        guard let serviceUrl = URL(string: urlString) else {
            let serviceError = WebserviceError(type: .invalidUrl(url: urlString))
            onCompletion(serviceError, nil)
            return
        }
        Alamofire.request(serviceUrl, method: method, parameters: parameters, headers: headers).validate().response(queue: queue) { response in
            guard response.response?.statusCode != nil,
                response.response?.statusCode == 200 else {
                    let serviceError = WebserviceError(type: .invalidResponseCode(code: response.response?.statusCode ?? 0))
                onCompletion(serviceError, nil)
                return
            }
            onCompletion(nil, response.data)
        }
    }
}
