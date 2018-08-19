//
//  CLPlacemark+Helper.swift
//  DoorDash
//
//  Created by Satisha AM on 8/12/18.
//  Copyright © 2018 Satisha AM. All rights reserved.
//

import Foundation
import CoreLocation

extension CLPlacemark {
    var compactAddress: String? {
        if let name = name {
            var result = name
            if let city = locality {
                result += ", \(city)"
            }
            return result
        }
        return nil
    }
}
