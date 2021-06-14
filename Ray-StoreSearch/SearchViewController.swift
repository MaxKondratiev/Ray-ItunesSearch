//
//  ViewController.swift
//  Ray-StoreSearch
//
//  Created by максим  кондратьев  on 14.06.2021.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    var searchResults = [SearchResult]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell" , for: indexPath)
        let ekzOfsearchResult = searchResults[indexPath.row]
        cell.textLabel?.text =  ekzOfsearchResult.name
        cell.detailTextLabel?.text = ekzOfsearchResult.artistName
        
        return cell
    }
    
    
}
