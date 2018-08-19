//
//  tableCell.swift
//  DoorDash
//
//  Created by Satisha AM on 8/11/18.
//  Copyright © 2018 Satisha AM. All rights reserved.
//

import Foundation
import UIKit

class TableCell: UITableViewCell {
    
    var name:UILabel!
    var storeDescription:UILabel!
    var deliveryFee:UILabel!
    var asapTime:UILabel!
    var myImageView:UIImageView!
    var containerView:UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureCell()  {
        setupRightContainerView()
        
        myImageView = UIImageView()
        myImageView.contentMode = .scaleAspectFit
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        myImageView.image = UIImage(named: "placeholder")

        self.contentView.addSubview(myImageView)

        let views:[String:Any] = ["containerView": containerView, "myImageView":myImageView]
        let matrics:[String:Any] = ["vpadding": 10.0, "hpadding":10.0]
        var constraintsArray:[NSLayoutConstraint] = []

        myImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.3).isActive = true
       constraintsArray += NSLayoutConstraint.constraints(withVisualFormat: "|-10.0-[myImageView]-(15)-[containerView]-(10.0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: matrics, views: views)
        constraintsArray +=  NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=12)-[myImageView(==70@950)]-(>=12.0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: matrics, views: views)
        containerView.topAnchor.constraint(equalTo: myImageView.topAnchor).isActive = true
        constraintsArray += NSLayoutConstraint.constraints(withVisualFormat: "V:[containerView]-(>=10.0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: matrics, views: views)
        NSLayoutConstraint.activate(constraintsArray)
    }
    
    private func setupRightContainerView() {
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)

        name = UILabel()
        name.numberOfLines = 0
        name.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .headline).pointSize, weight: .semibold)
        name.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(name)
        
        storeDescription = UILabel()
        storeDescription.numberOfLines = 0
        storeDescription.font = UIFont.preferredFont(forTextStyle: .subheadline)
        storeDescription.textColor = .gray
        storeDescription.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(storeDescription)

        deliveryFee = UILabel()
        deliveryFee.numberOfLines = 0
        deliveryFee.font = UIFont.preferredFont(forTextStyle: .subheadline)
        deliveryFee.translatesAutoresizingMaskIntoConstraints = false
        deliveryFee.textColor = .gray
        containerView.addSubview(deliveryFee)

        asapTime = UILabel()
        asapTime.numberOfLines = 0
        asapTime.font = UIFont.preferredFont(forTextStyle: .subheadline)
        asapTime.translatesAutoresizingMaskIntoConstraints = false
        asapTime.textAlignment = .right
        asapTime.textColor = .gray

        containerView.addSubview(asapTime)
        
        
        let views:[String:Any] = ["name": name,  "storeDescription": storeDescription, "deliveryFee": deliveryFee, "asapTime": asapTime]
        let matrics:[String:Any] = ["vpadding": 10.0, "hpadding":10.0]
        var constraintsArray:[NSLayoutConstraint] = []

       constraintsArray += NSLayoutConstraint.constraints(withVisualFormat: "|[name]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: matrics, views: views)
        constraintsArray += NSLayoutConstraint.constraints(withVisualFormat: "|[storeDescription]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: matrics, views: views)
       constraintsArray += NSLayoutConstraint.constraints(withVisualFormat: "|[deliveryFee]", options: NSLayoutFormatOptions(rawValue: 0), metrics: matrics, views: views)
       constraintsArray += NSLayoutConstraint.constraints(withVisualFormat: "[asapTime]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: matrics, views: views)

        constraintsArray += NSLayoutConstraint.constraints(withVisualFormat: "V:|[name]-[storeDescription]-10-[deliveryFee]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: matrics, views: views)

        NSLayoutConstraint.activate(constraintsArray)

        asapTime.centerYAnchor.constraint(equalTo: deliveryFee.centerYAnchor).isActive = true
        deliveryFee.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.65).isActive = true
        asapTime.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.3).isActive = true
    }
    
    func setCellData(storeInfo:StoreInfo) {
        name.text  = storeInfo.name
        storeDescription.text  = storeInfo.storeDescription
        deliveryFee.text  = storeInfo.deliveryFee
        asapTime.text = storeInfo.asapTime
    }
}
