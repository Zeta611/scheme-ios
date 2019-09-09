//
//  Tokenizer.swift
//  Scheme-Swift
//
//  Created by Jaeho Lee on 07/09/2019.
//  Copyright © 2019 Jaeho Lee. All rights reserved.
//

import Foundation

class Tokenizer {

  var stream: StringStream

  private var tokens = [Token]()
  private var index = -1

  init(stream: StringStream = StringStream()) {
    self.stream = stream
  }
}


extension Tokenizer {

  func get() -> Token? {
    index += 1
    if index < tokens.count {
      return tokens[index]
    }

    guard let c = stream.peek() else { return nil }

    let token: Token
    switch c {
    case isWhitespace:
      token = Whitespace(value: getFromStream(while: isWhitespace))

    case isParenthesis:
      token = Parenthesis(value: getFromStream())

    case isNumber:
      token = Number(value: getFromStream(while: isNumber))

    case isOperator:
      token = Operator(rawValue: getFromStream())!

    case isLetter:
      let value = getFromStream(while: isLetter)
      if Keyword.allCases.map({ $0.rawValue }).contains(value) {
        token = Keyword(rawValue: value)!
      } else {
        token = Variable(value: value)
      }

    default:
      fatalError("Invalid character: \(c)")
    }

    tokens.append(token)
    return token
  }


  func putBack() {
    index -= 1
  }
}


private extension Tokenizer {

  func getFromStream(while condition: (Character) -> Bool) -> String {
    var string = ""
    while let character = stream.peek(), condition(character) {
      string.append(stream.get()!)
    }
    return string
  }

  func getFromStream() -> String {
    guard let character = stream.get() else { return "" }
    return String(character)
  }


  func isWhitespace(_ c: Character) -> Bool {
    return c.isWhitespace
  }


  func isLetter(_ c: Character) -> Bool {
    switch c {
    case "a"..."z", "A"..."Z":
      return true
    case "0"..."9":
      return true
    case "_", "-":
      return true
    default:
      return false
    }
  }


  func isNumber(_ c: Character) -> Bool {
    return ("0"..."9").contains(c)
  }


  func isParenthesis(_ c: Character) -> Bool {
    return ["(", ")"].contains(c)
  }


  func isOperator(_ c: Character) -> Bool {
    return Operator.allCases.map { Character($0.rawValue) }.contains(c)
  }
}


private func ~= (pattern: (Character) -> (Bool), value: Character) -> Bool {
  return pattern(value)
}
