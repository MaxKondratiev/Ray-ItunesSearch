//
//  ViewController.swift
//  Ray-StoreSearch
//
//  Created by максим  кондратьев  on 14.06.2021.
//

import UIKit
import Foundation

class SearchViewController: UIViewController {
    
    struct TableView {
        struct CellIdentifiers {
            static let searchResultCell = "SearchResultCell"
        }
    }
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    var searchResults = [SearchResult]()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        let nibCell = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: .main)
        tableView.register(nibCell, forCellReuseIdentifier: "xibCell")
        
    }


}

extension SearchViewController: UISearchBarDelegate  {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        for i in 0...15 {
            let ekzOfSearchResult = SearchResult()
            ekzOfSearchResult.name = String(format: "Fake results %d for ", i)
            ekzOfSearchResult.artistName = searchBar.text!
            searchResults.append(ekzOfSearchResult)
        }
        tableView.reloadData()
        
}
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        .topAttached
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "xibCell" , for: indexPath) as! SearchResultCell
        
        let ekzOfsearchResult = searchResults[indexPath.row]
        cell.nameLabel.text =  ekzOfsearchResult.name
        cell.artistNameLabel?.text = ekzOfsearchResult.artistName
        
        return cell
    }
    
    
}
