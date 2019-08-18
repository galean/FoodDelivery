//
//  RestaurantsTableViewHeaderCell.swift
//  FoodDelivery
//
//  Created by Galean Pallerman on 18.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import UIKit

class RestaurantsTableViewHeaderCell: UITableViewCell {
    static let cellIdentifier = "RestaurantsTableViewHeaderCell"

    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(with titleText: String) {
        titleLabel.text = titleText
    }
}
