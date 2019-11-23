//
//  UserUtil.swift
//  WouldYouRather
//
//  Created by Yash Patel on 11/15/19.
//  Copyright © 2019 Yash Patel. All rights reserved.
//

import Foundation
import UIKit

class UserUtil {
    
    public static func prepareId(btn: UIButton) {
        checkUser { (i) in
            if i != -1 {
                Helper.saveUserId(id: i)
                btn.isEnabled = true
                print("User Id retrieved")
            }
            else if i == -1 {
                    insertUser { (i) in
                    Helper.saveUserId(id: i)
                    btn.isEnabled = true
                    print("User stored.")
                }
            }
        }
    }
    
    private static func insertUser(completion: @escaping (Int) -> ()) {
        let parameters = ["deviceUuid": UIDevice.current.identifierForVendor!.uuidString, "deviceType": UIDevice.modelName]
        let url = URL(string: Helper.COMMON_URL + "insertuser")! //change the url
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            do {
            //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    if let id = json["uid"] as? Int {
                        DispatchQueue.main.async {
                            completion(id)
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    private static func checkUser(completion: @escaping (Int) -> ()) {
            let parameters = ["deviceUuid": UIDevice.current.identifierForVendor!.uuidString, "deviceType": UIDevice.modelName]
            let url = URL(string: Helper.COMMON_URL + "checkuser")! //change the url
            let session = URLSession.shared
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            do {
                if let status = response?.getStatusCode() {
                    if status == 404 {
                        DispatchQueue.main.async {
                            completion(-1)
                        }
                    }
                    else if status == 200 {
                        if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                            if let id = json["uid"] as? Int {
                                DispatchQueue.main.async {
                                    completion(id)
                                }
                            }
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
}
