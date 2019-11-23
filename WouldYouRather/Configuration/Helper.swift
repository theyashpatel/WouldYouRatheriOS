//
//  Helper.swift
//  WouldYouRather
//
//  Created by Yash Patel on 11/13/19.
//  Copyright © 2019 Yash Patel. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    public static let COMMON_URL = "https://wouldyouratherapi.astridgroup.com/"
    public static let CORNER_RADIUS: CGFloat = 10
    
    public static var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    public static func showSimpleAlert(controller: UIViewController, completion: @escaping () -> ()) {
        let alert = UIAlertController(title: "Alert", message: "message", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            completion()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { _ in
            //Cancel Action
        }))
        controller.present(alert, animated: true, completion: nil)
    }
    
    public static func startActivity(view: UIView) {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
//        view.addSubview(activityIndicator)
//        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    public static func stopActivity(view: UIView) {
//        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
    public static func downloadImage(from urlString: String, imageView: UIImageView) {
        let url = URL(string: urlString)!
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                imageView.image = UIImage(data: data)
            }
        }
    }
    
    private static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    public static func saveUserId(id: Int) {
        let d = UserDefaults.standard
        d.set(id, forKey: "userId")
    }
    
    public static func getUserId() -> Int {
        let d = UserDefaults.standard
        return d.integer(forKey: "userId")
    }
    
}

extension URLResponse {

    func getStatusCode() -> Int? {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return nil
    }
}
