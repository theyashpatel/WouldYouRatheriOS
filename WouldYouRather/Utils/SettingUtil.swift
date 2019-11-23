//
//  SettingUtil.swift
//  WouldYouRather
//
//  Created by Yash Patel on 11/19/19.
//  Copyright © 2019 Yash Patel. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class SettingUitl {

    public static func muteUnmuteSoundPressed(isMute: Bool, imgView: UIImageView) {
        let d = UserDefaults.standard
        d.set(isMute, forKey: "isMute")
        if isMute {
            imgView.image = UIImage(named: "mute")
        }
        else {
            imgView.image = UIImage(named: "unmute")
        }
    }
    
    public static func isMute() -> Bool {
        return UserDefaults.standard.bool(forKey: "isMute")
    }
    
    public static func storeSound(name: String) {
        UserDefaults.standard.set(name, forKey: "soundName")
    }
    
    public static func getSound() -> String {
        let s: String? = UserDefaults.standard.string(forKey: "soundName")
        if let ss = s {
            return ss
        }
        return "Buddy"
    }
}
