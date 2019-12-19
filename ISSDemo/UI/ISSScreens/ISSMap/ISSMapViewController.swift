//
//  ISSMapViewController.swift
//  ISSDemo
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class ISSMapViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longtitudeLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var trackSwitch: UISwitch!
    
    /// View model
    let viewModel = ISSMapViewModel()
    /// Realm notification token
    var issLocationUpdateToken: NotificationToken?
    /// Annotation
    let annotationIdentifier = "ISSAnnotationView"
    lazy var issAnnotation: ISSAnnotation = {
        return ISSAnnotation(coordinate: self.viewModel.getCurrentISSLocation())
    }()
    
    // MARK: - UI lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateMapView()
        updateInfoView()
        viewModel.startISSLocationPulling()
        issLocationUpdateToken = ISSLocation.current().observe { [weak self] _ in
            self?.updateMapView()
            self?.updateInfoView()
        }
    }
    
    deinit {
        issLocationUpdateToken?.invalidate()
        viewModel.stopISSLocationPulling()
    }
    
    // MARK: - Methods
    
    fileprivate func updateMapView() {
        centerMapOnLocation()
        updateISSAnnotation()
    }
    
    fileprivate func centerMapOnLocation() {
        guard trackSwitch.isOn else {
            return
        }
        mapView?.setRegion(viewModel.getCurrentISSLocactionMapRegion(), animated: true)
    }
    
    fileprivate func updateISSAnnotation() {
        if mapView.annotations.count == 0 {
            mapView.addAnnotation(issAnnotation)
        } else {
            issAnnotation.coordinate = viewModel.getCurrentISSLocation()
        }
    }
    
    fileprivate func updateInfoView() {
        infoView.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.5)
        latitudeLabel.text = "Latitude: \(viewModel.getCurrentISSLocation().latitude)"
        longtitudeLabel.text = "Longitude: \(viewModel.getCurrentISSLocation().longitude)"
        lastUpdateLabel.text = "Last update: \(ISSLocation.current().date())"
    }
}

// MARK: - MKMapViewDelegate

extension ISSMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        /// Only displays the ISSAnnotation
        guard let annotation = annotation as? ISSAnnotation else { return nil }

        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        annotationView.image = UIImage(named: "ISSIcon")
        return annotationView
    }
}

extension ISSMapViewController: MenuDetailsControllerProtocol {
    static func instantiateFromStoryboard() -> UIViewController? {
        return UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "ISSMapViewController") as? ISSMapViewController
    }
}
