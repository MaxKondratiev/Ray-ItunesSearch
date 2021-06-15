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
    
    @IBOutlet weak var segmentContol: UISegmentedControl!
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        print(segmentContol.selectedSegmentIndex)
    }
    
    
    // VARIABLES
    var dataTask : URLSessionDataTask?
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
    
    
    let urlString = String(format: "https://itunes.apple.com/search?term=%@&limit=200",encodedText.localizedLowercase)
    
    let url = URL(string: urlString)
    
    return url!
}



func parseData(_ data: Data) -> [SearchResult] {
    do {
        let resultofSearch = try JSONDecoder().decode(ResultArray.self, from: data)
        return resultofSearch.results
    } catch {
        print("\n -----Error is \(error)")
        
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
            dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                else if let httpResponse = response as? HTTPURLResponse,   httpResponse.statusCode == 200 {
                    if let data = data {
                        self.searchResults = parseData(data)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                     }
                
            }
            dataTask?.resume()
            

            
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
