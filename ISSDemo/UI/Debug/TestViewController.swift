//
//  TestViewController.swift
//  ISSDemo
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import UIKit
import RealmSwift

class TestViewController: UIViewController {

    let locationUpdater = LocationUpdater()
    var token : NotificationToken?
    
    @IBOutlet weak var latitudeLabel: UILabel?
    @IBOutlet weak var longitudeLabel: UILabel?
    @IBOutlet weak var altitudeLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationUpdater.startLocationUpdates()
        setObserverToken()
    }
    
    /// Subscribes the changes of LocationStream item in Realm
    func setObserverToken() {
        
        token = LocationStream.current().observe { [weak self] change in
            switch change {
            case .change(_):
                DispatchQueue.main.async {
                    self?.latitudeLabel?.text = String(LocationStream.current().latitude() ?? 0)
                    self?.longitudeLabel?.text = String(LocationStream.current().longitude() ?? 0)
                    self?.altitudeLabel?.text = String(LocationStream.current().altitude() ?? 0)
                }
            case .deleted:
                DispatchQueue.main.async {
                    self?.latitudeLabel?.text = "Data deleted"
                    self?.longitudeLabel?.text = "Data deleted"
                    self?.altitudeLabel?.text = "Data deleted"
                }
            case .error(let error):
                NSLog(error.localizedDescription)
            }
        }
    }


    deinit {
        /// Stop location service
        locationUpdater.stopLocationUpdates()
        /// Remove subscription
        token?.invalidate()
    }
}

extension TestViewController: MenuDetailsControllerProtocol {
    
    static func instantiateFromStoryboard() -> UIViewController? {
        return UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "TestViewController") as? TestViewController
    }
}

