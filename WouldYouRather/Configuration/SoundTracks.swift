//
//  SoundTracks.swift
//  WouldYouRather
//
//  Created by Yash Patel on 11/19/19.
//  Copyright © 2019 Yash Patel. All rights reserved.
//

import Foundation

enum SoundTracks: CustomStringConvertible {
    case Energy
    case Sunny
    case Buddy
    
    var description: String {
        switch self {
        case .Energy: return "Energy"
        case .Sunny: return "Sunny"
        case .Buddy: return "Buddy"
        }
    }
}
