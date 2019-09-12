//
//  Node.swift
//  Scheme-Swift
//
//  Created by Jaeho Lee on 13/09/2019.
//  Copyright © 2019 Jaeho Lee. All rights reserved.
//

import Foundation

class Node {

  var left: Int
  var right: Int

  convenience init() {
    self.init(left: 0, right: 0)
  }

  init(left: Int, right: Int) {
    self.left = left
    self.right = right
  }
}


extension Node: CustomStringConvertible {

  var description: String {
    return "(left: \(left), right: \(right))"
  }
}
