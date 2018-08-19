//
//  QueryData.swift
//  DoorDash
//
//  Created by Satisha AM on 8/11/18.
//  Copyright © 2018 Satisha AM. All rights reserved.
//

import Foundation

class QueryData  {
    
    typealias sucess = ([StoreInfo])->()
    typealias error = (String)->()
   
    private var dataTask:URLSessionDataTask?
    private let session:URLSession = {
       let session  = URLSession(configuration:.default)
        return session
    }()
    
    private func constructURLWith(lat:Double, long:Double) -> URL? {
        var urlComponent = URLComponents(string: "https://api.doordash.com/v1/store_search")
        let queryItemToken = URLQueryItem(name: "lat", value: String(lat))
        let queryItemQuery = URLQueryItem(name: "lng", value: String(long))
        urlComponent?.queryItems = [queryItemToken, queryItemQuery]
        return urlComponent?.url
    }
    
    func fetchDataUsing(lat:Double, long:Double, successBlock:@escaping sucess, errorBlock:@escaping error) {
        dataTask?.cancel()
        guard let url = constructURLWith(lat: lat, long: long) else {return}
        dataTask = session.dataTask(with: url, completionHandler: {[weak self](data, response, err) in
            if let error = err {
                DispatchQueue.main.async {
                    errorBlock(error.localizedDescription)
                }
            } else {
                if let jsonData = data, let res = response as? HTTPURLResponse,  res.statusCode == 200 {
                    let res = self?.processData(serverData: jsonData)
                        DispatchQueue.main.async {
                        successBlock(res!)
                    }
                }
            }
        })
        dataTask?.resume()
    }
    
    private func processData(serverData:Data) -> [StoreInfo] {
        var storeInfoArray:[StoreInfo] = []
        do {
            if let  jsonObject:[Any] = try JSONSerialization.jsonObject(with: serverData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [Any]{
                for storeInfo in jsonObject {
                    if let storeDetails = storeInfo as? [String:Any] {
                        if let name = storeDetails["name"] as? String,
                           let description = storeDetails["description"] as? String,
                           let deliveryFee = storeDetails["delivery_fee"] as? Int,
                           let storeImage = storeDetails["cover_img_url"] as? String {
                            
                            var duration = ""
                            if let asapTime = storeDetails["asap_time"] as? Int {
                                duration = String(asapTime)+" min"
                            }
                            var deleiveryCost = "Free delivery"
                            if deliveryFee > 0 {
                                deleiveryCost = String(deliveryFee)
                            }
                            storeInfoArray.append(StoreInfo(name: name, storeDescription: description, deliveryFee: deleiveryCost, asapTime: duration, storeImageUrl:storeImage))
                        }
                    }
                }
            }
        } catch {
            
        }
        return storeInfoArray
    }
}
