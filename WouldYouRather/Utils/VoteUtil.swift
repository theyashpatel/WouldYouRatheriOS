//
//  VoteUtil.swift
//  WouldYouRather
//
//  Created by Yash Patel on 11/15/19.
//  Copyright © 2019 Yash Patel. All rights reserved.
//

import Foundation

class VoteUtil {
    public static func addVote(v: Vote, completion: @escaping () -> ()) {
        addVoteRequest(v: v) { (d, r, e) in
            guard e == nil else { return }
            do {
                //create json object from data
                if let s = r?.getStatusCode() {
                    if s == 200 {
                        DispatchQueue.main.async {
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    public static func getAllCount(qid: Int, completion: @escaping (Int, Int) -> ()) {
        getVoteCount(qid: qid, completion: completion)
    }
    
    private static func getVoteCount(qid: Int, completion: @escaping (Int, Int) -> ()) {
        let url = URL(string: Helper.COMMON_URL + "vote/" + String(qid))!
        URLSession.shared.dataTask(with: url) { (d, r, e) in
            guard e == nil else { return }
            guard let d = d else { return }
            do {
               //create json object from data
               if let json = try JSONSerialization.jsonObject(with: d, options: .mutableContainers) as? [String: Any] {
                let totalVote = json["totalVote"] as! Int
                let aVote = json["aVote"] as! Int
                 DispatchQueue.main.async {
                    completion(totalVote, aVote)
                 }
             }
            } catch let error {
              print(error.localizedDescription)
             }
        }.resume()
    }
    
    private static func addVoteRequest(v: Vote, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let parameters: [String: Any] = ["uid": v.getUid(), "qid": v.getQid(), "voteValue": v.getVoteValue()]
        let url = URL(string: Helper.COMMON_URL + "addvote")! //change the url
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
        session.dataTask(with: request as URLRequest, completionHandler: completion).resume()
    }
}
