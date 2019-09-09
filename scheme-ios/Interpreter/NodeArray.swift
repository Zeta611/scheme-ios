//
//  NodeArray.swift
//  Scheme-Swift
//
//  Created by Jaeho Lee on 06/09/2019.
//  Copyright © 2019 Jaeho Lee. All rights reserved.
//

import Foundation

typealias NodeArray = [Node]

struct Node {
  var left: Int
  var right: Int

  static var zero = Node(left: 0, right: 0)
}


extension Node: CustomStringConvertible {

  var description: String {
    return "(left: \(left), right: \(right))"
  }
}
