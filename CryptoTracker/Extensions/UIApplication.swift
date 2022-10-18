//
//  UIApplication.swift
//  CryptoTracker
//
//  Created by Dev C Krishna on 18/10/22.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
