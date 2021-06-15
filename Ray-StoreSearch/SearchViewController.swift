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
       performSearch()
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
        let detailVC = segue.destination as! DetailViewController
        let indexPath = sender as! IndexPath
        let searchResult = searchResults[indexPath.row]
        detailVC.searchResult = searchResult
    }
    }
    //Когда DidelectRowat запускает Segue, он отправляет вдоль пути индекса выбранной строки. Что позволяет вам найти объект SearchResult и передавать его на DetailViewController 
    //
}


//NETWORKING
func itunesURL (searchText: String, category: Int) -> URL {
  
    let kind : String
    switch category {
    case 1: kind = "musicTrack"
    case 2: kind = "software"
    case 3: kind = "ebook"
    default: kind = ""
    }
    
    
    let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let urlString = String(format: "https://itunes.apple.com/search?term=%@&limit=200&entity=\(kind)",encodedText.localizedLowercase)
    
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
    func performSearch() {
        if !searchBar.text!.isEmpty {
            resignFirstResponder()
            
            let url = itunesURL(
                searchText: searchBar.text!,
                category: segmentContol.selectedSegmentIndex
                )
                
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch()
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
        cell.configureCell(for: result)
        return cell
        }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetail", sender: indexPath)
    }
    
    }
    
    

