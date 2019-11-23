//
//  Vote.swift
//  WouldYouRather
//
//  Created by Yash Patel on 11/15/19.
//  Copyright © 2019 Yash Patel. All rights reserved.
//

import Foundation

class Vote {
    private var uid: Int
    private var qid: Int
    private var voteValue: String
    
    init(uid: Int, qid: Int, voteValue: String) {
        self.uid = uid
        self.qid = qid
        self.voteValue = voteValue
    }
    
    public func getUid() -> Int {
        return self.uid
    }
    
    public func getQid() -> Int {
        return self.qid
    }
    
    public func getVoteValue() -> String {
        return self.voteValue
    }
}
