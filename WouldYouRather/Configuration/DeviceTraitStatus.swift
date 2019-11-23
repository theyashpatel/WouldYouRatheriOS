//
//  DeviceTraitStatus.swift
//  UniversalApp
//
//  Created by Yash Patel on 11/12/19.
//  Copyright © 2019 Yash Patel. All rights reserved.
//

import Foundation
import UIKit

enum DeviceTraitStatus {
    ///IPAD and others: Width: Regular, Height: Regular
    case wRhR
    ///Any IPHONE Portrait Width: Compact, Height: Regular
    case wChR
    ///IPHONE Plus/Max Landscape Width: Regular, Height: Compact
    case wRhC
    ///IPHONE landscape Width: Compact, Height: Compact
    case wChC

    static var current:DeviceTraitStatus{

        switch (UIScreen.main.traitCollection.horizontalSizeClass, UIScreen.main.traitCollection.verticalSizeClass){

        case (UIUserInterfaceSizeClass.regular, UIUserInterfaceSizeClass.regular):
            return .wRhR
        case (UIUserInterfaceSizeClass.compact, UIUserInterfaceSizeClass.regular):
            return .wChR
        case (UIUserInterfaceSizeClass.regular, UIUserInterfaceSizeClass.compact):
            return .wRhC
        case (UIUserInterfaceSizeClass.compact, UIUserInterfaceSizeClass.compact):
            return .wChC
        default:
            return .wChR

        }
    }
}
