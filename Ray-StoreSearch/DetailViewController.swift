//
//  DetailViewController.swift
//  Ray-StoreSearch
//
//  Created by максим  кондратьев  on 15.06.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    var searchResult: SearchResult!
    
    var downloadTask :URLSessionDownloadTask?
    //OUTLETS
    
    @IBOutlet var popupView: UIView!
    @IBOutlet var artworkImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var artistNameLabel: UILabel!
    @IBOutlet var kindLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var priceButton: UIButton!
    
    
    func updateUI() {
        nameLabel.text = searchResult.name
        if searchResult.artist.isEmpty {
            artistNameLabel.text = "Unknown"
            
        } else {
            artistNameLabel.text = searchResult.artist
            
        }
        kindLabel.text = searchResult.type
        genreLabel.text = searchResult.genre
        
        //Price  label
       let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = searchResult.currency
        let priceText: String
        if searchResult.price == 0 {
            priceText = "Free"
        }
        else if let text = formatter.string(from: searchResult.price as NSNumber) {
            priceText = text
            
        } else {
            priceText = ""
        }
         priceButton.setTitle(priceText, for: .normal)
        //Image
        
        if let largeURL = URL(string: searchResult.imageLarge) {
            downloadTask = artworkImageView.loadImage(url: largeURL) }
        
        
    }
    @IBAction func openInStore()
    {   if let url = URL(string: searchResult.storeUrl) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    }
    @IBAction func closeVc(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if searchResult != nil {
            updateUI()
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
