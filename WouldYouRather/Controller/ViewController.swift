//
//  ViewController.swift
//  WouldYouRather
//
//  Created by Yash Patel on 11/12/19.
//  Copyright © 2019 Yash Patel. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var muteImg: UIImageView!
    @IBOutlet weak var musicTxt: UITextField!
    
    var sounds = ["Buddy", "Energy", "Sunny"]
    
    var player = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        }else{
            print("Internet Connection not Available!")
        }
        setPickerView()
        setupMuteImage(imageView: muteImg)
        setUpId(button: playBtn)
        playBtn.layer.cornerRadius = playBtn.frame.height / Helper.CORNER_RADIUS
        musicTxt.layer.cornerRadius = playBtn.frame.height / Helper.CORNER_RADIUS
    }

    
    @IBAction func playPressed(_ sender: UIButton) {
    }
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupMuteImage(imageView: UIImageView) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        SettingUitl.muteUnmuteSoundPressed(isMute: SettingUitl.isMute(), imgView: imageView)
        playSound(soundName: SettingUitl.getSound())
        print(SettingUitl.isMute())
        if SettingUitl.isMute() {
            player.stop()
        }
    }
    
    @objc private func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if muteImg.image == UIImage(named: "mute") {
            SettingUitl.muteUnmuteSoundPressed(isMute: false, imgView: muteImg)
            player.stop()
            playSound(soundName: SettingUitl.getSound())
        }
        else if muteImg.image == UIImage(named: "unmute") {
            SettingUitl.muteUnmuteSoundPressed(isMute: true, imgView: muteImg)
            player.stop()
        }
    }
    
    private func playSound(soundName: String) {
        let url = Bundle.main.url(forResource: soundName, withExtension: "mp3")
        guard url != nil else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.soloAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url!)
            player.numberOfLoops = -1
            player.play()
        }
        catch {
            print("error")
        }
    }
    
    private func setUpId(button: UIButton) {
        if Helper.getUserId() == 0 {
            UserUtil.prepareId(btn: button)
        } else {
            button.isEnabled = true
        }
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    private func setPickerView() {
        createPickerView()
        createToolBar()
        musicTxt.text = SettingUitl.getSound()
    }
    
    private func createPickerView() {
        let picker = UIPickerView()
        picker.delegate = self
        musicTxt.inputView = picker
    }
    
    private func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(toolBarDone))
        toolBar.setItems([flexibleSpace, doneBtn], animated: false)
        toolBar.isUserInteractionEnabled = true
        musicTxt.inputAccessoryView = toolBar
        
        toolBar.barTintColor = .black
        toolBar.tintColor = .white
    }
    
    @objc private func toolBarDone() {
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sounds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sounds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        musicTxt.text = sounds[row]
        SettingUitl.storeSound(name: sounds[row])
        if !SettingUitl.isMute() {
            player.stop()
            playSound(soundName: sounds[row])
        }
    }
}
