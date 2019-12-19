//
//  ISSCompassViewController.swift
//  ISSDemo
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation

class ISSCompassViewController: ISSBaseViewController {

    // MARK: - Properties
    
    let viewModel = ISSCompassViewModel()
    
    // MARK: - UI Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.startPullingData()
    }
    
    deinit {
        viewModel.stopPullingData()
    }
    
    // MARK: - Methods
    
    /// Setup Realm notification tokens to subscribe changes
    override func setupRealmTokens() {
        /// When device heading updated, move compass
        deviceHeadingUpdateToken = DeviceTrueHeading.current().observe { [weak self] _ in
            UIView.animate(withDuration: 0.2) {
                self?.issContainerImageView.transform = CGAffineTransform(rotationAngle: DeviceTrueHeading.current().transformationAngle())
            }
            self?.updateDebugViews()
        }
        /// When device location or ISS location changed, update ISSIcon location on compass
        deviceLocationUpdateToken = LocationStream.current().observe { [weak self] _ in
            self?.updateCompassISSIcon()
            self?.updateDebugViews()
        }
        issLocationUpdateToken = ISSLocation.current().observe { [weak self] _ in
            self?.updateCompassISSIcon()
            self?.updateDebugViews()
        }
    }
    
    /// Update ISSIcon position by:
    /// 1. get BearingAngle from device position to ISS position
    /// 2. calculate ISSIcon relative coordinate to compass center
    /// 3. show ISSIcon and update its location point layout constraints
    fileprivate func updateCompassISSIcon() {
        guard let bearingAngle = viewModel.getCurrentBearingAngle() else {
            return
        }
        
        let compassRadius: Double = Double(issContainerImageView.bounds.size.width / 2)
        let issRelativePoint = viewModel.getISSIconRelativeCoorindates(compassRadius: compassRadius,
                                                                       angle: bearingAngle)
        issIconView.isHidden = false
        issIconCenterXConstraint.constant = issRelativePoint.x
        /// calculate center based on origin of superview (0, 0), not center of compass
        /// subtract value of y if y is positive, add value of y if y is negative
        issIconCenterYConstraint.constant = -issRelativePoint.y
    }
    
    override func updateDebugViews() {
        super.updateDebugViews()
        issBearingLabel?.text = "\(viewModel.getCurrentBearingAngle() ?? 0)"
    }
}

extension ISSCompassViewController: MenuDetailsControllerProtocol {
    static func instantiateFromStoryboard() -> UIViewController? {
        return UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "ISSCompassViewController") as? ISSCompassViewController
    }
}
