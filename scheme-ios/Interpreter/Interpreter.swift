//
//  Interpreter
//  Scheme-Swift
//
//  Created by Jaeho Lee on 07/09/2019.
//  Copyright © 2019 Jaeho Lee. All rights reserved.
//

import Foundation

final class Interpreter {

  static var main = Interpreter()

  var input: () -> String = { readLine() ?? "" }
  
  var output: (String) -> Void = {
    Swift.print($0, separator: "", terminator: "")
  }

  private(set) lazy var tokenizer = Tokenizer()
  private(set) var nodeArray = NodeArray()
  private(set) var symbolTable = HashTable<String, Int>(size: 997)


  init(input: @escaping () -> String, output: @escaping (String) -> Void) {
    self.input = input
    self.output = output
  }

  init() {}
}


extension Interpreter {

  func run(once: Bool = false) {
    while true {
      if tokenizer.stream.isEmpty {
        Swift.print("λ", terminator: " ")
        tokenizer.stream.insert(input())
      }

      preprocess()
      let rootNodeIndex = read()
      print(rootNodeIndex, startList: true)

      if tokenizer.stream.isAtEnd {
        tokenizer.stream.flush()
        Swift.print()
        if once { break }
      }
    }
  }
}


private extension Interpreter {

  func preprocess() {
  }


  /// Recursively reads tokens from a tokenizer.
  ///
  /// - Returns: The index of a root node for tokens between the pair of
  /// parentheses, or the negative hash value for a single token. The index is
  /// one-based, in order to identify a terminator with a zero.
  func read() -> Int {
    guard var startingToken = tokenizer.get() else { return 0 }

    // Skip whitespaces
    while startingToken.type == .whitespace {
      guard let token = tokenizer.get() else { return 0 }
      startingToken = token
    }

    guard let tokenHashValue = symbolTable
      .insert(key: startingToken.value, element: nil)
      else { fatalError("symbolTable is full") }

    // Immediately return the hash value of a non-parenthesis starting token.
    guard startingToken.isEqual(to: Parenthesis.left)
      else { return -tokenHashValue }

    var isRootNode = true

    // One-based index for the root node of a current `read` call.
    var rootNodeIndex = 0

    // One-based index that tracks current node.
    var currentNodeIndex = 0

    // Repeat adding a node until the token reaches a right parenthesis.
    while let token = tokenizer.get(), !token.isEqual(to: Parenthesis.right) {
      guard token.type != .whitespace else { continue }

      guard let tokenHashValue = symbolTable
        .insert(key: token.value, element: nil)
        else { fatalError("symbolTable is full") }

      // Allocate a new node, and set `currentNodeIndex` as the index of it.
      nodeArray.append(.zero)
      if isRootNode {
        rootNodeIndex = nodeArray.count
        isRootNode = false
      } else {
        nodeArray[currentNodeIndex - 1].right = nodeArray.count
      }
      currentNodeIndex = nodeArray.count

      // If the token is a left perenthesis, recursively set `left` of the node
      // and put it back, since `read` begins parsing from a left parenthesis;
      // Otherwise set `left` as a negative hash value.
      if token.isEqual(to: Parenthesis.left) {
        tokenizer.putBack()
        nodeArray[currentNodeIndex - 1].left = read()
      } else {
        nodeArray[currentNodeIndex - 1].left = -tokenHashValue
      }
    }
    return rootNodeIndex
  }


  /// Recursively prints the expression starting from the root node.
  ///
  /// - Parameters:
  ///   - rootNodeIndex: The one-based index of the root node.
  ///   - startList: A flag which indicates if the root node is at the start of
  ///     the list.
  func print(_ rootNodeIndex: Int, startList: Bool) {
    if rootNodeIndex == 0 {
      output("() ")
    } else if rootNodeIndex < 0 {
      output(symbolTable.getKey(from: -rootNodeIndex) ?? "Unknown symbol")
      output(" ")
    } else if rootNodeIndex > 0 {
      if startList { output("( ") }

      print(nodeArray[rootNodeIndex - 1].left, startList: true)

      if nodeArray[rootNodeIndex - 1].right != 0 {
        print(nodeArray[rootNodeIndex - 1].right, startList: false)
      } else {
        output(") ")
      }
    }
  }
}
