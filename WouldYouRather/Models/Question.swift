//
//  Question.swift
//  WouldYouRather
//
//  Created by Yash Patel on 11/13/19.
//  Copyright © 2019 Yash Patel. All rights reserved.
//

import Foundation

public class Question {
    private var id: Int
    private var question: String
    private var oneOption: String
    private var twoOption: String
    private var oneImage: String
    private var twoImage: String
    private var category: [String]
    private var isnsfw: String
    
    init(id: Int, question: String, oneOption: String, twoOption: String,
             oneImage: String, twoImage: String, category: [String], isnsfw: String) {
        self.id = id
        self.question = question
        self.oneOption = oneOption
        self.twoOption = twoOption
        self.oneImage = oneImage
        self.twoImage = twoImage
        self.category = category
        self.isnsfw = isnsfw
    }
    
    public func getId() -> Int {
        return self.id
    }
    
    public func getQuestion() -> String {
        return self.question
    }
    
    public func getOneOption() -> String {
        return self.oneOption
    }
    
    public func getTwoOption() -> String {
        return self.twoOption
    }
    
    public func getOneImage() -> String {
        return self.oneImage
    }
    
    public func getTwoImage() -> String {
        return self.twoImage
    }
    
    public func getCategory() -> [String] {
        return self.category
    }
    
    public func getIsnsfw() -> String {
        return self.isnsfw
    }
}
