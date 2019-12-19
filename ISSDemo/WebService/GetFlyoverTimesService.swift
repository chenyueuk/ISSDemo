//
//  GetFlyoverTimesService.swift
//  ISSDemo
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import Alamofire
import RealmSwift

class GetFlyoverTimesService: BaseWebservice {

    // MARK: - Properties
    let urlString: String
    var urlParameters: Parameters = [:]
    
    // MARK: - Initializers
    
    /// Initializes the GetFlyoverTimesService with an optional url string.
    ///
    /// - Parameters:
    ///   - urlString: url string to get the flyover times. Default to http://api.open-notify.org/iss-pass.json
    init(urlString: String = "http://api.open-notify.org/iss-pass.json") {
        self.urlString = urlString
        super.init()
    }
    
    // MARK: - Methods
    
    /// Http request call to fetch FlyoverTimes from the set URL
    ///
    /// - Parameters:
    ///   - latitude: latitude of flyover point location
    ///   - longitude: longitude of flyover point location
    ///   - altitude: altitude of flyover point location, optional, default to be 20 (valid range is 1-100,000)
    ///   - count: number of ISS passes to get
    func getFlyoverTimes(latitude: Double,
                         longitude: Double,
                         altitude: Double = 20,
                         count: Int = 5) {
        urlParameters = ["lat": String(latitude),
                         "lon": String(longitude),
                         "alt": String(altitude),
                         "n": String(count)]
        
        dataRequest(urlString, method: .get, parameters: urlParameters) { error, data in
            /// Error should be handled in 'BaseWebService', if anything wrong here, it is an unknown error.
            guard let responseData = data, error == nil else {
                let serviceError = WebserviceError(type: .invalidData(data: data))
                NSLog(serviceError.errorMessage())
                return
            }
            
            do {
                let issPassTimes = try JSONDecoder().decode(ISSPassTimes.self, from: responseData)
                try? Realm.defaultInstance().write {
                    ISSPassTimes.current().updateFlyoverTimes(issPassTimes.flyoverTimes)
                }
            } catch {
                let serviceError = WebserviceError(type: .decodingError(data: responseData))
                NSLog(serviceError.errorMessage())
            }
        }
    }
}
