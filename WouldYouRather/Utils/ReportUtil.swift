//
//  ReportUtil.swift
//  WouldYouRather
//
//  Created by Yash Patel on 11/23/19.
//  Copyright © 2019 Yash Patel. All rights reserved.
//

import Foundation

class ReportUtil {
    public static func reportQuestion(qid: Int, completion: @escaping (Int) -> ()) {
        let url = URL(string: Helper.COMMON_URL + "report/" + String(qid))!
        URLSession.shared.dataTask(with: url) { (d, r, e) in
            guard e == nil else { return }
            if let status = r?.getStatusCode() {
                DispatchQueue.main.async {
                    completion(status)
                }
            }
        }.resume()
    }
}
