//
//  UIViewController+hideKeyboardWhenTappedAround.swift
//
//  Created by Jay Lee on 18/02/2019.
//  Copyright © 2019 Jay Lee <jaeho.lee@snu.ac.kr>
//  This work is free. You can redistribute it and/or modify it under the
//  terms of the Do What The Fuck You Want To Public License, Version 2,
//  as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
//

import UIKit

extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }

  @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
}
