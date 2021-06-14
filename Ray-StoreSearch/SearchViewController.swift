//
//  ViewController.swift
//  Ray-StoreSearch
//
//  Created by максим  кондратьев  on 14.06.2021.
//

import UIKit
import Foundation

class SearchViewController: UIViewController {
    
//Mark* - Outlers
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
 // VARIABLES
    var searchResults = [SearchResult]()
    struct TableView {
        struct CellIdentifiers {
            static let searchResultCell = "SearchResultCell"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
 //MARK* - Register Xib Cell
        
        let nibCell = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: .main)
        tableView.register(nibCell, forCellReuseIdentifier: "xibCell")
    }
}


//NETWORKING
func itunesURL (searchText: String) -> URL {
    let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    
    
    let urlString = String(format: "https://itunes.apple.com/search?term=%@",encodedText.localizedLowercase)
    
    let url = URL(string: urlString)
    
    return url!
}

func performStoreRequest(with url: URL) -> String? {
    do {
        return try String(contentsOf: url, encoding: .utf8)
    } catch {
        print("Download Error is \(error.localizedDescription)")
         return nil   }
    
}


//MARK* - SEARCH BAR
extension SearchViewController: UISearchBarDelegate  {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            resignFirstResponder()
            
            let url = itunesURL(searchText: searchBar.text!)
           
            if let jsonString = performStoreRequest(with: url) {
                print("Our Json is \(jsonString)")
            }
            
            
           tableView.reloadData()
        }
       
        
}
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        .topAttached
    }
}
//MARK* - Delegates/DataSourse
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
