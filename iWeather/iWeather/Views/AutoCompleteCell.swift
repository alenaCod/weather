//
//  AutoCompleteCell.swift
//  iWeather
//
//  Created by Mac on 7/29/18.
//  Copyright © 2018 Alona Moiseyenko. All rights reserved.
//

import Foundation
import UIKit

class AutoCompleteCell: UITableViewCell {
    
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(location: JSONLocation) {
        locationLabel?.text = location.name
    }
}
