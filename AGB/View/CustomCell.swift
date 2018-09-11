//
//  CustomCell.swift
//  AGB
//
//  Created by Alain Gabellier on 10/09/2018.
//  Copyright © 2018 Alain Gabellier. All rights reserved.
//

import UIKit
import SwipeCellKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var bottomLine: UILabel!
    @IBOutlet weak var reccurent: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}
