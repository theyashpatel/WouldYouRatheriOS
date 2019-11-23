//
//  QuestionVC.swift
//  WouldYouRather
//
//  Created by Yash Patel on 11/13/19.
//  Copyright © 2019 Yash Patel. All rights reserved.
//

import UIKit

class QuestionVC: UIViewController {
    
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var aOptionBtn: UIButton!
    @IBOutlet weak var bOptionBtn: UIButton!
    @IBOutlet weak var showPictureBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var shareImageBtn: UIImageView!
    @IBOutlet weak var reportImageBtn: UIImageView!
    @IBOutlet weak var aImg: UIImageView!
    @IBOutlet weak var bImg: UIImageView!
    @IBOutlet weak var aSuccess: UIImageView!
    @IBOutlet weak var bSuccess: UIImageView!
    @IBOutlet weak var aOptionView: UIView!
    @IBOutlet weak var bOptionView: UIView!
    @IBOutlet weak var aStatsLbl: UILabel!
    @IBOutlet weak var bStatsLbl: UILabel!
    @IBOutlet weak var aImageHeightCt: NSLayoutConstraint!
    @IBOutlet weak var aImageWeightCt: NSLayoutConstraint!
    @IBOutlet weak var bImageHeightCt: NSLayoutConstraint!
    @IBOutlet weak var bImageWeightCt: NSLayoutConstraint!
    
    @IBOutlet var outterViewCollection: [UIView]!
    
    private var currentQuestion:Int = 0
    private var totalCount = 0
    private var aCount = 0
    private var bCount = 0
    
    private var smallDeviceImageSize: CGFloat = 100;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideOutterViews()
        setupShareImage(imageView: shareImageBtn)
        setupReportImage(imageView: reportImageBtn)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        aOptionView.backgroundColor = .white
        bOptionView.backgroundColor = .white
        changeSmallScreenImageSize()
        adjustButtonView(button: aOptionBtn)
        adjustButtonView(button: bOptionBtn)
        getQuestionAndPopulate()
        addCornerRadiusToAll()
        changeFontSizeForSmallDevice()
        buttonViewConfigforRR()
        adjustQuestion()
    }
    
    @IBAction func optionPressed(_ sender: UIButton) {
        if sender.tag == 1{
            aSuccess.isHidden = false
        }
        else if sender.tag == 2 {
            bSuccess.isHidden = false
        }
        let s = sender.tag == 1 ? "a" : "b"
        let v = Vote(uid: Helper.getUserId(), qid: currentQuestion, voteValue: s)
        VoteUtil.addVote(v: v) {
            Helper.startActivity(view: self.view)
            VoteUtil.getAllCount(qid: self.currentQuestion) { (tCount, aCount) in
                Helper.stopActivity(view: self.view)
                self.totalCount = tCount
                self.aCount = aCount
                self.postVote(sender: sender)
            }
        }
    }
    
    @IBAction func nextPressed(_ sender: UIButton) {
        getQuestionAndPopulate()
        aSuccess.isHidden = true
        bSuccess.isHidden = true
        aStatsLbl.isHidden = true
        bStatsLbl.isHidden = true
        aOptionBtn.isEnabled = true
        bOptionBtn.isEnabled = true
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showPicturePressed(_ sender: UIButton) {
        if UIDevice.current.shouldHideStatus {
            if aSuccess.isHidden == false {
                if sender.titleLabel?.text == "Show Pictures" {
                    aStatsLbl.isHidden = true
                }
                else if sender.titleLabel?.text == "Show Options" {
                    aStatsLbl.isHidden = false
                }
            }
            else if bSuccess.isHidden == false {
                if sender.titleLabel?.text == "Show Pictures" {
                    bStatsLbl.isHidden = true
                }
                else if sender.titleLabel?.text == "Show Options" {
                    bStatsLbl.isHidden = false
                }
            }
        }
        
        if sender.titleLabel?.text == "Show Pictures" {
            isTextHidden(bool: true)
            isImageHidden(bool: false)
            sender.setTitle("Show Options", for: .normal)
        }
        else if sender.titleLabel?.text == "Show Options" {
            isTextHidden(bool: false)
            isImageHidden(bool: true)
            sender.setTitle("Show Pictures", for: .normal)
        }
    }
    
    private func setupShareImage(imageView: UIImageView) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(shareTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupReportImage(imageView: UIImageView) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(reportTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func reportTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let alert = UIAlertController(title: "Report Question", message: "Are you sure? 🤔", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            var result = ""
            ReportUtil.reportQuestion(qid: self.currentQuestion) { (status) in
                Helper.startActivity(view: self.view)
                if status == 200 {
                    result = "Successfully Reported. Thank you 😀"
                }
                else if status == 400 {
                    result = "Currently unable to report 😕"
                }
                else if status == 500 {
                    result = "Please check your internet connection 🧐"
                }
                Helper.stopActivity(view: self.view)
                

                let newalert = UIAlertController(title: result, message: nil, preferredStyle: .alert)
                newalert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
                }))
                self.present(newalert, animated: true, completion: nil)
            }            
            }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func shareTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        shareQuestionAlertView(sender: shareImageBtn)
    }
    
    private func shareQuestionAlertView(sender: UIView) {
         var text = ""
        if let question = questionLbl.text, let a = aOptionBtn.titleLabel?.text, let b = bOptionBtn.titleLabel?.text {
            text = "\(question)\na) \(a)\nb) \(b)"
            if totalCount > 0 {
                text += "\n\nVotes\nTotal: \(totalCount)\na: \(aCount)\nb: \(totalCount - aCount)"
            }
        } else {
            text = "Error getting text."
        }
        
        var shareData = [Any]()
        if let a = aImg.image, let b = bImg.image {
            shareData = [a, b,text] as [Any]
        }
        else {
            shareData = [text]
        }
         let activityViewController = UIActivityViewController(activityItems: shareData, applicationActivities: nil)
         activityViewController.popoverPresentationController?.sourceView = sender // so that iPads won't crash
        
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,
                                                         UIActivity.ActivityType.print, UIActivity.ActivityType.addToReadingList,
                                                         UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.postToVimeo,
                                                         UIActivity.ActivityType.openInIBooks, UIActivity.ActivityType.postToTencentWeibo,
                                                         UIActivity.ActivityType.saveToCameraRoll, UIActivity.ActivityType.postToFlickr,
                                                         UIActivity.ActivityType.postToTwitter]

         // present the view controller
         self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func changeFontSizeForSmallDevice() {
        if UIDevice.current.shouldChangeBtnFontSize {
            backBtn.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
            skipBtn.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
            showPictureBtn.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        }
    }
    
    private func buttonViewConfigforRR() {
        if DeviceTraitStatus.current == .wRhR {
            aOptionView.backgroundColor = UIColor.clear.withAlphaComponent(0.2)
            bOptionView.backgroundColor = UIColor.clear.withAlphaComponent(0.2)
            aOptionBtn.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 30)
            bOptionBtn.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 30)
        }
    }
    
    private func postVote(sender: UIButton) {
        let part = sender.tag == 1 ? aCount : totalCount - aCount
        let resultStr = "\(calculatePercentage(total: totalCount, part: part))% @ Votes: \(totalCount)"
        
        if sender.tag == 1 {
            aStatsLbl.text = resultStr
            aStatsLbl.isHidden = false
            aOptionBtn.isEnabled = false
            bOptionBtn.isEnabled = false
        }
        else {
            bStatsLbl.text = resultStr
            bStatsLbl.isHidden = false
            aOptionBtn.isEnabled = false
            bOptionBtn.isEnabled = false
            
        }
        
    }
    
    private func changeSmallScreenImageSize() {
        if UIDevice.current.shouldChangeImageSize {
            changeImageSizeCosntant(constraint: aImageHeightCt)
            changeImageSizeCosntant(constraint: aImageWeightCt)
            changeImageSizeCosntant(constraint: bImageHeightCt)
            changeImageSizeCosntant(constraint: bImageWeightCt)
        }
    }
    
    private func changeImageSizeCosntant(constraint: NSLayoutConstraint) {
        constraint.constant = smallDeviceImageSize
    }
    
    private func calculatePercentage(total: Int, part: Int) -> Double {
        if part == 0 {
            return 0
        }
        let t: Double = Double(total)
        let p: Double = Double(part)
        print("Pre: \((p/t) * 100) Percent: \((round((p/t) * 10000)) / 100)")
        let percent: Double = (round((p/t) * 10000)) / 100
        return percent
    }
    
    private func addCornerRadiusToAll() {
        addCornerRadius(control: showPictureBtn)
        addCornerRadius(control: skipBtn)
        addCornerRadius(control: aImg)
        addCornerRadius(control: bImg)
        addCornerRadius(control: aOptionView)
        addCornerRadius(control: bOptionView)
        addCornerRadius(control: backBtn)
    }
    
    private func adjustQuestion() {
        questionLbl.adjustsFontSizeToFitWidth = true
        questionLbl.minimumScaleFactor = 0
        questionLbl.numberOfLines = 0
    }
    
    private func addCornerRadius(control: UIView) {
        control.layer.cornerRadius = control.frame.height / Helper.CORNER_RADIUS
    }
    
    private func adjustButtonView(button: UIButton) {
        button.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.minimumScaleFactor = 0
        button.isExclusiveTouch = true
        addCornerRadius(control: button)
    }
    
    private func hideOutterViews() {
        for eachView in outterViewCollection {
            eachView.backgroundColor = UIColor.clear
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func isTextHidden(bool: Bool) {
        if bool {
            UIView.animate(withDuration: 0.3, animations: {
                Helper.startActivity(view: self.view)
                self.aOptionBtn.alpha = 0
                self.bOptionBtn.alpha = 0
                self.aOptionView.backgroundColor = UIColor.clear.withAlphaComponent(0.2)
                self.bOptionView.backgroundColor = UIColor.clear.withAlphaComponent(0.2)
            }) { (isDone) in
                Helper.stopActivity(view: self.view)
            }
            
        }
        else {
            UIView.animate(withDuration: 0.3, animations: {
                Helper.startActivity(view: self.view)
                self.aOptionBtn.alpha = 1
                self.bOptionBtn.alpha = 1
                self.aOptionView.backgroundColor = UIColor.white.withAlphaComponent(1)
                self.bOptionView.backgroundColor = UIColor.white.withAlphaComponent(1)
            }) { (isDone) in
                Helper.stopActivity(view: self.view)
            }
        }
    }
    
    private func isImageHidden(bool: Bool) {
        aImg.isHidden = bool
        bImg.isHidden = bool
    }
    
    
    private func getQuestionAndPopulate() {
        if Reachability.isConnectedToNetwork() {
            getRandomQuestion()
        }
        else {
            questionLbl.text = "Not connected to Internet. Once connected press Next!"
        }
    }
    public func getRandomQuestion() {
        Helper.startActivity(view: self.view)
        let url = URL(string: Helper.COMMON_URL + "brandom")!
        var res: Question?
        //create dataTask using the session object to send data to the server
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in

            guard error == nil else {
                return
            }

            guard let data = data else {
                return
            }

           do {
              //create json object from data
              if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                print(json)
                let id = json["id"] as! Int
                let question = json["question"] as! String
                let oneOption = json["oneOption"] as! String
                let twoOption = json["twoOption"] as! String
                let oneImage = json["oneImage"] as! String
                let twoImage = json["twoImage"] as! String
                let category = json["category"] as! [String]
                let isnsfw = json["isnsfw"] as! String
                
                res = Question(id: id, question: question.firstUppercased, oneOption: oneOption.firstUppercased, twoOption: twoOption.firstUppercased, oneImage: oneImage, twoImage: twoImage, category: category, isnsfw: isnsfw)
                DispatchQueue.main.async {
                    print("\n\n\n\(res!.getId())\n\n\n")
                    self.currentQuestion = res!.getId()
                    self.questionLbl.text = res!.getQuestion()
                    let aString = NSAttributedString(string: res!.getOneOption())
                    self.aOptionBtn.setAttributedTitle(aString, for: .normal)
                    let bString = NSAttributedString(string: res!.getTwoOption())
                    self.bOptionBtn.setAttributedTitle(bString, for: .normal)
                    Helper.downloadImage(from: res!.getOneImage(), imageView: self.aImg)
                    Helper.downloadImage(from: res!.getTwoImage(), imageView: self.bImg)
                    Helper.stopActivity(view: self.view)
                }
            }
           } catch let error {
             print(error.localizedDescription)
            Helper.stopActivity(view: self.view)
            }
        })

        task.resume()
    }
}
