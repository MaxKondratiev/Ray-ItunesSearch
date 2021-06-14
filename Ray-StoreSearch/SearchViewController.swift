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

func performStoreRequest(with url: URL) -> Data? {
    do {
        return try Data(contentsOf: url)
    } catch {
        print("\n --- Download Error is \(error.localizedDescription)")
        showNetworkError()
        
    }
         return nil
    
}

func parseData(_ data: Data) -> [SearchResult] {
    do {
        let resultofSearch = try JSONDecoder().decode(ResultArray.self, from: data)
        return resultofSearch.results
    } catch {
        print("Error is \(error)")
         return []
    }
}
func showNetworkError() {
    let alert = UIAlertController(title: "Ooops", message: "There was an error accessing the iTunes Store.", preferredStyle: .alert)
    let  action = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alert.addAction(action)
    alert.present(alert, animated: true, completion: nil)
    
}

//MARK* - SEARCH BAR
extension SearchViewController: UISearchBarDelegate  {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            resignFirstResponder()
            
            let url = itunesURL(searchText: searchBar.text!)
           
            if let data = performStoreRequest(with: url) {
              //Вместо этого мы подставили наш экземпляр класса и ячейки заполнились данными
//                let results = parseData(data)
//                print("Our RESULTS are: \(results)")
                
                searchResults = parseData(data)
                //по алфавиту
                searchResults.sort { (result1, result2) -> Bool in
                    return result1.artist.localizedStandardCompare(result2.artist) == .orderedAscending
                }
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
        
        let result = searchResults[indexPath.row]
        cell.nameLabel.text =  result.name
        if result.artist.isEmpty {
            cell.artistNameLabel.text = "Unknow"
        } else {
            cell.artistNameLabel.text = String(format: "%@ (%@)", result.artist, result.type)
            
        }
        
        return cell
    }
    
    
}
