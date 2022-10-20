//
//  HapticManager.swift
//  CryptoTracker
//
//  Created by Dev C Krishna on 20/10/22.
//

import Foundation
import SwiftUI

class HapticManager {
    
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
    
}
