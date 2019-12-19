//
//  GetISSLocationService.swift
//  ISSDemo
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import Alamofire
import RealmSwift

class GetISSLocationService: BaseWebservice {

    // MARK: - Properties
    let urlString: String
    
    // MARK: - Initializers
    
    /// Initializes the GetFlyoverTimesService with an optional url string.
    ///
    /// - Parameters:
    ///   - urlString: url string to get the flyover times. Default to http://api.open-notify.org/iss-now.json
    init(urlString: String = "http://api.open-notify.org/iss-now.json") {
        self.urlString = urlString
        super.init()
    }
    
    // MARK: - Methods
    
    /// Http request call to fetch ISS location from URL call
    ///
    func getISSLocation() {
        dataRequest(urlString, method: .get) { error, data in
            /// Error should be handled in 'BaseWebService', if anything wrong here, it is an unknown error.
            guard let responseData = data, error == nil else {
                let serviceError = WebserviceError(type: .invalidData(data: data))
                NSLog(serviceError.errorMessage())
                return
            }
            
            do {
                let issLocation = try JSONDecoder().decode(ISSLocation.self, from: responseData)
                try? Realm.defaultInstance().write {
                    ISSLocation.current().updateISSLocation(timestamp: issLocation.timestamp,
                                                            latitude: issLocation.latitude,
                                                            longitude: issLocation.longitude)
                }
            } catch {
                let serviceError = WebserviceError(type: .decodingError(data: responseData))
                NSLog(serviceError.errorMessage())
            }
        }
    }
}
