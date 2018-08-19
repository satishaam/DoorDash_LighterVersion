//
//  ExploreViewController.swift
//  DoorDash
//
//  Created by Satisha AM on 8/11/18.
//  Copyright © 2018 Satisha AM. All rights reserved.
//

import UIKit
import CoreLocation

class ExploreViewController: UIViewController {

    private let selectedTabbarItemImageName = "tab-explore"
    private let navbarButtonItemAddessImageName = "nav-address"

    @IBOutlet weak var navAddress: UIBarButtonItem!
    @IBOutlet weak var storeListTableView: UITableView!
    
    var tableView:UITableView!
    var storeDetails:[StoreInfo] = []
    var imageCache:NSCache<AnyObject, AnyObject>  = NSCache()
    var currenLocation:CLLocation?
     let dataFetchObject = QueryData()
    
    var loadingIndicator:UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView(frame: CGRect.zero)
        loading.activityIndicatorViewStyle = .whiteLarge
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.color = .red
        loading.hidesWhenStopped = true
        loading.stopAnimating()
        return loading
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.tabBarItem.selectedImage = UIImage(named: selectedTabbarItemImageName)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navAddress.image = UIImage(named: navbarButtonItemAddessImageName)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        // to make nav bar title red in color
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.red]
        // set up table view and register custom table cell
        setupViews()
        tableView.register(TableCell.self, forCellReuseIdentifier: "storecell")
        
        // check for user previous location, if any then retrive the store list based on previous location, else show map view to select location.
        if UserDefaults.standard.object(forKey: "lat") != nil &&  UserDefaults.standard.object(forKey: "long") != nil {
            queryDataWith(lat: UserDefaults.standard.double(forKey: "lat"), long: UserDefaults.standard.double(forKey: "long"))
        } else {
            showMapView()
        }
    }
    
    @IBAction func openMapView(_ sender: Any) {
        showMapView()
    }
    
    func queryDataWith(lat:Double, long:Double)  {
        currenLocation = CLLocation(latitude: lat, longitude: long)
        UserDefaults.standard.set(lat, forKey: "lat")
        UserDefaults.standard.set(long, forKey: "long")
        loadingIndicator.startAnimating()
        dataFetchObject.fetchDataUsing(lat:lat, long: long, successBlock: { (storesData:[StoreInfo]) in
            self.storeDetails = storesData
            self.tableView.reloadData()
            self.loadingIndicator.stopAnimating()

        }) { (erroStr) in
            self.loadingIndicator.stopAnimating()
            let alert = UIAlertController(title: "", message: "Some error occurred while processing your request, please try again later", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        }
    }

    func showMapView() {
        performSegue(withIdentifier: "mapview", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navCtrl  = segue.destination as! UINavigationController
        let destVC : MapViewController = navCtrl.viewControllers.first as! MapViewController
        destVC.savedCLLocation =  currenLocation
        destVC.parentViewCtrl = self
    }

    func setupViews() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)

        tableView.delegate = self
        tableView.dataSource = self
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10.0),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10.0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10.0),
            loadingIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

