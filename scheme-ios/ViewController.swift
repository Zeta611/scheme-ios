//
//  ViewController.swift
//  scheme-ios
//
//  Created by Jaeho Lee on 10/09/2019.
//  Copyright © 2019 Jay Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  private let semaphore = DispatchSemaphore(value: 0)
  private let interpreterQueue = DispatchQueue.global(qos: .userInteractive)
  private var segment = 0

  private lazy var textField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.borderStyle = .line
    textField.delegate = self
    return textField
  }()

  private lazy var label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.layer.borderWidth = 1
    label.numberOfLines = 0
    return label
  }()

  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.tableFooterView = UIView()
    return tableView
  }()

  private lazy var button: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(switchSegment), for: .touchUpInside)
    button.setTitleColor(.black, for: .normal)
    button.setTitle("Symbol Table: Touch to Switch", for: .normal)
    return button
  }()


  @objc private func switchSegment(_ sender: UIButton) {
    if segment == 0 {
      button.setTitle("Node Array: Touch to Switch", for: .normal)
      segment = 1
    } else {
      button.setTitle("Symbol Table: Touch to Switch", for: .normal)
      segment = 0
    }
    tableView.reloadData()
  }

  override func loadView() {
    let view = UIView()
    view.backgroundColor = .white
    view.translatesAutoresizingMaskIntoConstraints = false
    self.view = view

    let views = [
      "textField": textField,
      "label": label,
      "button": button,
      "tableView": tableView,
    ]
    views.values.forEach { view.addSubview($0) }
    [
      NSLayoutConstraint.constraints(
        withVisualFormat: "V:[textField(==40)]-[label(==40)]-[button(==40)]-[tableView]|",
        options: .alignAllLeading,
        metrics: nil,
        views: views),
      NSLayoutConstraint.constraints(
        withVisualFormat: "H:|-[textField(==label,==button,==tableView)]-|",
        metrics: nil,
        views: views),
    ]
      .forEach { NSLayoutConstraint.activate($0) }
    textField.topAnchor
      .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
      .isActive = true
  }


  override func viewDidLoad() {
    super.viewDidLoad()

    Interpreter.main.input = {
      self.semaphore.wait()
      var text: String = ""
      DispatchQueue.main.sync {
        text = self.textField.text ?? ""
        self.textField.text = ""
      }
      return text
    }

    Interpreter.main.output = { output in
      DispatchQueue.main.sync {
        if self.label.text == nil {
          self.label.text = output
        } else {
          self.label.text!.append(output)
        }
        self.tableView.reloadData()
      }
    }

    interpreterQueue.async {
      Interpreter.main.run()
    }

    hideKeyboardWhenTappedAround()
  }
}


extension ViewController: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    semaphore.signal()
    label.text?.removeAll()
    return true
  }
}


extension ViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if segment == 1 {
      return Interpreter.main.nodeArray.count
    } else {
      return Interpreter.main.symbolTable.count
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    if segment == 1 {
      let node = Interpreter.main.nodeArray[indexPath.row]
      let left = node.left
      let right = node.right
      if left < 0, let value = Interpreter.main.symbolTable.getKey(from: -left) {
        cell.textLabel?.text = "\(indexPath.row + 1): left \(left) (\(value)), right \(right)"
      } else {
        cell.textLabel?.text = "\(indexPath.row + 1): left \(left), right \(right)"
      }
    } else {
      let table = Interpreter.main.symbolTable.table.enumerated().filter { $0.element.key != nil }
      let offset = table[indexPath.row].offset
      let key = table[indexPath.row].element.key!
      cell.textLabel?.text = "\(-offset): '\(key)'"
    }
    return cell
  }
}
