//
//  UIImageView+DownloadImage.swift
//  Ray-StoreSearch
//
//  Created by максим  кондратьев  on 15.06.2021.
//

import Foundation
import UIKit

extension UIImageView{
    func loadImage(url: URL) -> URLSessionDownloadTask {
//        This is similar to a data task, but it saves the downloaded file to a temporary location on disk instead of keeping it in memory
        let downloadTask = URLSession.shared.downloadTask(with: url) {[weak self](url, _, error) in
            if error == nil ,
               let  url = url,
            let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    if let weakSelf = self {
                        weakSelf.image = image
                    }
                }
                }
        }
        downloadTask.resume()
        return downloadTask
    }
}
