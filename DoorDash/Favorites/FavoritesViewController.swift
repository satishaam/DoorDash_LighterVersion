//
//  FavoritesViewController.swift
//  DoorDash
//
//  Created by Satisha AM on 8/11/18.
//  Copyright © 2018 Satisha AM. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    private let selectedTabbarItemImageName = "tab-star"

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem?.selectedImage = UIImage(named: selectedTabbarItemImageName)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

