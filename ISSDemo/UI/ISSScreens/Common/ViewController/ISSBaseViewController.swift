//
//  ISSBaseViewController.swift
//  ISSDemo
//
//  Created by YUE CHEN on 19/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import UIKit
import RealmSwift

class ISSBaseViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var issContainerImageView: UIImageView!
    
    /// Debug views
    @IBOutlet weak var topDebugView: UIStackView?
    @IBOutlet weak var bottomDebugView: UIStackView?
    
    @IBOutlet weak var deviceLatitudeLabel: UILabel?
    @IBOutlet weak var deviceLongitudeLabel: UILabel?
    @IBOutlet weak var deviceHeadingLabel: UILabel?
    @IBOutlet weak var issLatitudeLabel: UILabel?
    @IBOutlet weak var issLongitudeLabel: UILabel?
    @IBOutlet weak var issLastUpdateLabel: UILabel?
    @IBOutlet weak var issBearingLabel: UILabel?
    
    var deviceHeadingUpdateToken: NotificationToken?
    var deviceLocationUpdateToken: NotificationToken?
    var issLocationUpdateToken: NotificationToken?
    
    lazy var issIconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ISSIcon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        imageView.clipsToBounds = false
        return imageView
    }()
    
    // MARK: - UI Layout constraints
    
    lazy var issIconCenterXConstraint: NSLayoutConstraint = {
        return issIconView.centerXAnchor.constraint(equalTo: issContainerImageView.centerXAnchor)
    }()
    
    lazy var issIconCenterYConstraint: NSLayoutConstraint = {
        return issIconView.centerYAnchor.constraint(equalTo: issContainerImageView.centerYAnchor)
    }()
    
    // MARK: - UI Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupRealmTokens()
        updateDebugViews()
    }
    
    deinit {
        invalidateRealmTokens()
    }
    
    // MARK: - Methods
    
    fileprivate func setupViews() {
        /// ISSIcon may have area outside of compass view bounds
        issContainerImageView.clipsToBounds = false
        /// Add ISSIcon, but is it by default hidden and centered in superview
        addISSIconView()
    }
    
    /// Add ISSIcon view to the CompassView, this cannot be done via Storyboard
    /// (Apple does not support adding subview to UIImageView)
    fileprivate func addISSIconView() {
        issContainerImageView.addSubview(issIconView)
        NSLayoutConstraint.activate([
            issIconView.heightAnchor.constraint(equalToConstant: 39),
            issIconView.widthAnchor.constraint(equalToConstant: 39),
            issIconCenterXConstraint,
            issIconCenterYConstraint
        ])
    }
    
    /// Setup Realm notification tokens to subscribe changes
    func setupRealmTokens() {
        /// default do not subscribe
    }
    
    /// Invalidates all Realm notification tokens in this class
    func invalidateRealmTokens() {
        deviceHeadingUpdateToken?.invalidate()
        deviceLocationUpdateToken?.invalidate()
        issLocationUpdateToken?.invalidate()
    }
    
    /// Update debug information
    func updateDebugViews() {
        #if targetEnvironment(simulator)
        topDebugView?.isHidden = false
        bottomDebugView?.isHidden = false
        
        /// Device info
        deviceHeadingLabel?.text = "\(DeviceTrueHeading.current().trueHeading)"
        deviceLatitudeLabel?.text = "\(LocationStream.current().latitude() ?? 0)"
        deviceLongitudeLabel?.text = "\(LocationStream.current().longitude() ?? 0)"
        
        /// ISS info
        issLatitudeLabel?.text = "\(ISSLocation.current().latitude)"
        issLongitudeLabel?.text = "\(ISSLocation.current().longitude)"
        issLastUpdateLabel?.text = "\(ISSLocation.current().date())"
        #else
        topDebugView?.isHidden = true
        bottomDebugView?.isHidden = true
        #endif
    }
}
