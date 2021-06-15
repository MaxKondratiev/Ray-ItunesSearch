//
//  SearchResultCell.swift
//  Ray-StoreSearch
//
//  Created by максим  кондратьев  on 14.06.2021.
//

import UIKit

class SearchResultCell: UITableViewCell {

    var downloadTask : URLSessionDownloadTask?
    
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell ( for result: SearchResult) {
          nameLabel.text = result.name
        if result.artist.isEmpty {
            artistNameLabel.text = "Unknown"
        } else {
            artistNameLabel.text = String(format: "%@ (%@)", result.artist, result.type)
            coverImage.image = UIImage(systemName: "square")
            if let smallUrl =  URL(string: result.imageSmall) {
                downloadTask = coverImage.loadImage(url: smallUrl)
            }
            
        }
    }

}
