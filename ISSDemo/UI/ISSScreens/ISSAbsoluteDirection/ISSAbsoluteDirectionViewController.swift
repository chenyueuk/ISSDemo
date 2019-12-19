//
//  ISSAbsoluteDirectionViewController.swift
//  ISSDemo
//
//  Created by YUE CHEN on 19/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import UIKit
import CoreLocation

class ISSAbsoluteDirectionViewController: ISSBaseViewController {

    // MARK: - Properties
    
    let viewModel = ISSAbsoluteDirectionViewModel()
    
    /// Debug views
    @IBOutlet weak var devicePitchLabel: UILabel?
    @IBOutlet weak var issElevationLabel: UILabel?
    
    // MARK: - UI Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.motionUpdateHandler = { [weak self] _,_ in
            DispatchQueue.main.async {
                self?.updateISSIconLocation()
                self?.updateDebugViews()
            }
        }
        viewModel.startPullingData()
    }
    
    deinit {
        viewModel.stopPullingData()
    }
    
    /// Setup Realm notification tokens to subscribe changes
    override func setupRealmTokens() {
        /// When device heading updated, device location or ISS location changed, update ISSIcon location on compass
        deviceHeadingUpdateToken = DeviceTrueHeading.current().observe { [weak self] _ in
            self?.updateISSIconLocation()
            self?.updateDebugViews()
        }
        deviceLocationUpdateToken = LocationStream.current().observe { [weak self] _ in
            self?.updateISSIconLocation()
            self?.updateDebugViews()
        }
        issLocationUpdateToken = ISSLocation.current().observe { [weak self] _ in
            self?.updateISSIconLocation()
            self?.updateDebugViews()
        }
    }
    
    /// Update the position of ISSIcon view
    fileprivate func updateISSIconLocation() {
        guard let xAngle = viewModel.angleBetweenHeadingAndBearing(),
            let yAngle = viewModel.angleBetweenPitchAndElevation() else {
            return
        }
        let hudRadius = Double(issContainerImageView.bounds.size.width / 2)
        let xOffset = viewModel.issIconXOffset(hudRadius: hudRadius, xAngle: xAngle)
        let yOffset = viewModel.issIconYOffset(hudRadius: hudRadius, yAngle: yAngle)
        
        issIconView.isHidden = false
        issIconCenterXConstraint.constant = CGFloat(xOffset)
        issIconCenterYConstraint.constant = CGFloat(yOffset)
    }
    
    override func updateDebugViews() {
        super.updateDebugViews()
        issBearingLabel?.text = "\(viewModel.getCurrentBearingAngle() ?? 0)"
        devicePitchLabel?.text = "\(viewModel.getDevicePitchAngle() ?? 0)"
        issElevationLabel?.text = "\(viewModel.getISSElevationAngle() ?? 0)"
    }
}

extension ISSAbsoluteDirectionViewController: MenuDetailsControllerProtocol {
    static func instantiateFromStoryboard() -> UIViewController? {
        return UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "ISSAbsoluteDirectionViewController") as? ISSAbsoluteDirectionViewController
    }
}
