//
//  MenuViewController.swift
//  ISSDemo
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import UIKit

/// ViewControllers that can be reached from MenuViewController should implement this protocol
protocol MenuDetailsControllerProtocol {
    /// Instantiate an instance of Self from storyboard, expecting an UIViewController type
    ///
    /// - Returns:the optional UIViewController instantiated from storyboard
    static func instantiateFromStoryboard() -> UIViewController?
}

class MenuViewController: UITableViewController {

    // MARK: - Properties
    
    let viewModel = MenuViewModel()
    
    // MARK: - UI lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableCell", for: indexPath)
        cell.textLabel?.text = viewModel.items[indexPath.row].description()
        return cell
    }
    
    // MARK: - Table view delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let type = viewModel.items[indexPath.row].getType()
        if let vc = type.instantiateFromStoryboard() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
