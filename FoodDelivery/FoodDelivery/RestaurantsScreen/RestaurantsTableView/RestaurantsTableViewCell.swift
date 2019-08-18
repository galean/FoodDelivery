//
//  RestaurantsTableViewCell.swift
//  FoodDelivery
//
//  Created by Galean Pallerman on 16.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import UIKit

class RestaurantsTableViewCell: UITableViewCell {
    static let cellIdentifier = "RestaurantsTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    var dataModel: RestaurantsTableViewCellDataModel?
    
    //MARK: Initialization
    func configure(with cellData: RestaurantsTableViewCellData) {
        dataModel = RestaurantsTableViewCellDataModel(with: cellData)
        
        titleLabel.text = cellData.name
        if let price = cellData.price {
            costLabel.text = "from" + " \(price)" + "₴"
        }
        if let delivery = cellData.delivery {
            deliveryTimeLabel.text = "~" + "\(delivery)" + "h"
        }
        if let rating = cellData.rating {
            ratingLabel.text = "\(rating) " + "stars"
        }
        if let categories = cellData.categories {
            categoriesLabel.text = "Categories: " + "\(categories)"
        }
    }
}
