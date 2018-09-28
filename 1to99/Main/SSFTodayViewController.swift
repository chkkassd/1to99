//
//  SSFTodayViewController.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/9/28.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import UIKit

class SSFTodayViewController: UIViewController {

    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        configureSearchController()
    }
    
    // MARK: - Private methods
    
    private func configureNavigationItem() {
        let leftImage = UIImage(named: "Navigationbar_add")?.withRenderingMode(.alwaysOriginal)
        let rightImage = UIImage(named: "Navigationbar_edit")?.withRenderingMode(.alwaysOriginal)
        addBarButtonItem.image = leftImage
        editBarButtonItem.image = rightImage
    }
    
    private func configureSearchController() {
        let todaySearchResultsVC = TodaySearchResultsViewController()
        let search = UISearchController(searchResultsController: todaySearchResultsVC)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
    }
    
    // MARK: - Interaction
    
    @IBAction func addBarButtonItemPressed(_ sender: Any) {
    }
    
    @IBAction func editBarButtonItemPressed(_ sender: Any) {
    }
}

extension SSFTodayViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todayTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TodayTableViewCell", for: indexPath) as! TodayTableViewCell
        return todayTableViewCell
    }
    

}

extension SSFTodayViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
