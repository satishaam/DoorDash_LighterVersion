//
//  TableDataSource+Delegates.swift
//  DoorDash
//
//  Created by Satisha AM on 8/11/18.
//  Copyright © 2018 Satisha AM. All rights reserved.
//

import Foundation
import UIKit

extension ExploreViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "storecell", for: indexPath) as? TableCell else { return UITableViewCell() }
        let storeInfo = storeDetails[indexPath.row]
        cell.setCellData(storeInfo: storeInfo)
        
        if imageCache.object(forKey: indexPath as AnyObject) != nil {
            let cachedImageData = imageCache.object(forKey: indexPath as AnyObject) as! UIImage
            cell.myImageView.image = cachedImageData
        } else {
            DispatchQueue.global().async {
                do {
                    if let image = try UIImage(data: Data(contentsOf: URL(string: storeInfo.storeImageUrl)!)) {
                        self.imageCache.setObject(image, forKey: indexPath as AnyObject)
                        DispatchQueue.main.async(execute: {
                            if let cell  = tableView.cellForRow(at: indexPath) as? TableCell {
                                cell.myImageView.image = image
                            }
                        })
                    }
                } catch {
                    
                }
            }
        }

        return cell
    }
}
