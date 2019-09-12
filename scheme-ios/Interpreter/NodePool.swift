//
//  MemoryPool.swift
//  Scheme-Swift
//
//  Created by Jaeho Lee on 13/09/2019.
//  Copyright © 2019 Jaeho Lee. All rights reserved.
//

import Foundation

class NodePool {

  private(set) var nodes = [Node]()
  private var freeNodeHeadIndex = 1
  private(set) var capacity = 0
  private var size = 0

  init(capacity: Int) {
    nodes = (2...capacity).map { Node(left: 0, right: $0) } + [Node()]
    self.capacity = capacity
  }
}


extension NodePool {

  func get(at index: Int) -> Node {
    return nodes[index - 1]
  }


  func allocate() -> Int {
    if size == capacity - 1 {
      reserveCapacity(minimumCapacity: capacity * 2)
    }
    size += 1
    let index = freeNodeHeadIndex
    let node = get(at: index)
    freeNodeHeadIndex = node.right
    node.right = 0
    return index
  }


  func deallocate(at index: Int) {
    size -= 1
    let node = get(at: index)

    if node.right > 0 {
      deallocate(at: node.right)
    }

    if node.left > 0 {
      deallocate(at: node.left)
    }

    node.left = 0
    node.right = freeNodeHeadIndex
    freeNodeHeadIndex = index
  }
}


private extension NodePool {

  func reserveCapacity(minimumCapacity: Int) {
    let newNodes = (capacity + 2...minimumCapacity)
      .map { Node(left: 0, right: $0) } + [Node()]

    var currentNode = get(at: freeNodeHeadIndex)
    while currentNode.right != 0 {
      currentNode = get(at: currentNode.right)
    }
    currentNode.right = capacity + 1

    nodes.append(contentsOf: newNodes)
    self.capacity = minimumCapacity
  }
}
