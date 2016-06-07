//
//  SearchController.swift
//  盗梦极客VR
//
//  Created by wl on 6/7/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit

class SearchController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var searchView: UIView!

    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchVC()
        topView.backgroundColor = UIColor.tintColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SearchController {
    func setupSearchVC() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchView.addSubview(searchController.searchBar)
        searchController.searchBar.placeholder = "请输入关键字"
        searchController.searchBar.delegate = self
        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.barTintColor = UIColor.tintColor()
        searchController.searchBar.tintColor = UIColor.whiteColor()
    }
}

extension SearchController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
    }
}

extension SearchController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    }
}