//
//  StringHelper.swift
//  WouldYouRather
//
//  Created by Yash Patel on 11/13/19.
//  Copyright © 2019 Yash Patel. All rights reserved.
//

import Foundation


extension StringProtocol {
    var firstUppercased: String {
        return prefix(1).uppercased() + dropFirst()
    }
    var firstCapitalized: String {
        return String(prefix(1)).capitalized + dropFirst()
    }
}
