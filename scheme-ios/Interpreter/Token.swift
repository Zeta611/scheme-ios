//
//  Token.swift
//  Scheme-Swift
//
//  Created by Jaeho Lee on 07/09/2019.
//  Copyright © 2019 Jaeho Lee. All rights reserved.
//

import Foundation

protocol Token {
  var value: String { get }
  var type: TokenType { get }
}


extension Token {

  func isEqual(to other: Token) -> Bool {
    return value == other.value && type == other.type
  }
}


struct Number: Token {
  var value: String
  let type = TokenType.number
}


enum Keyword: String, CaseIterable, Token {
  case define
  case lambda
  case `if`
  case cond

  var value: String { return rawValue }
  var type: TokenType { return .keyword }
}


enum Operator: String, CaseIterable, Token {
  case addition = "+"
  case subtraction = "-"
  case multiplication = "*"
  case division = "/"
  case modulus = "%"
  case equal = "="
  case greater = ">"
  case less = "<"

  var value: String { return rawValue }
  var type: TokenType { return .operator }
}


struct Parenthesis: Token {
  var value: String
  let type = TokenType.parenthesis

  static let left = Parenthesis(value: "(")
  static let right = Parenthesis(value: ")")
}


extension String: Token {
  var value: String { return self }
  var type: TokenType { return .string }
}


struct Variable: Token {
  var value: String
  let type = TokenType.variable
}


struct Whitespace: Token {
  var value: String
  let type = TokenType.whitespace
}
