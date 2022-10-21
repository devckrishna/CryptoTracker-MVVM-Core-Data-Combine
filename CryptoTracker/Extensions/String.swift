//
//  String.swift
//  CryptoTracker
//
//  Created by Dev C Krishna on 21/10/22.
//

import Foundation

extension String {
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
