//
//  TableViewCell.swift
//  scheme-ios
//
//  Created by Jaeho Lee on 11/09/2019.
//  Copyright © 2019 Jay Lee. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
