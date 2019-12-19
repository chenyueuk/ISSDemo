//
//  FlyoverTimesViewController.swift
//  ISSDemo
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import UIKit
import RealmSwift

class FlyoverTimesViewController: UITableViewController {

    // MARK: - Properties
    
    let viewModel = FlyoverTimesViewModel()
    var flyoverTimesUpdateToken: NotificationToken?
    
    // MARK: - UI lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flyoverTimesUpdateToken = ISSPassTimes.current().observe { [weak self] _ in
            /// reload table on FlyoverTime list changes
            self?.tableView.reloadData()
        }
        viewModel.getData()
    }
    
    deinit {
        flyoverTimesUpdateToken?.invalidate()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentFlyoverTimes().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FlyoverTimeTableCell",
                                                       for: indexPath) as? FlyoverTimeTableCell else {
            return UITableViewCell()
        }
        cell.setDate(viewModel.currentFlyoverTimes()[indexPath.row].date())
        return cell
    }
}

extension FlyoverTimesViewController: MenuDetailsControllerProtocol {
    
    static func instantiateFromStoryboard() -> UIViewController? {
        return UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "FlyoverTimesViewController") as? FlyoverTimesViewController
    }
}
