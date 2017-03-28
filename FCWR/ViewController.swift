//
//  ViewController.swift
//  FCWR
//
//  Created by zhuchenglong on 17/2/15.
//  Copyright © 2017年 goodcoder.zcl. All rights reserved.
//

import UIKit
import CoreMotion
import RealmSwift
import AVFoundation

class ViewController: UIViewController {
    let uiRealm = try! Realm()
    var lists : Results<Jiabin>!
    var lists2: Results<Haoma>!
    var audioPlayer = AVAudioPlayer()
    var status = true
    var paths:[URL] = [URL]()
    
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var imageResult: UIImageView!
    @IBOutlet weak var inputDataButton: UIButton!
    @IBOutlet weak var currentResult: UILabel!
    
    @IBOutlet weak var BoyOrGirl: UISegmentedControl!

    @IBAction func inputAllData(_ sender: UIButton) {
        lists = uiRealm.objects(Jiabin.self)
        if let tmp = lists {
            try! uiRealm.write{
                uiRealm.delete(tmp)
            }
        }
        lists2 = uiRealm.objects(Haoma.self)
        if let tmp = lists2 {
            try! uiRealm.write{
                uiRealm.delete(tmp)
            }
        }
        
        let boy = Jiabin()
        boy.xingbie = "male"
        
        for i in 0...2 {
            let person = Haoma()
            person.ID = i + 10
            boy.renshu.append(person)
        }
        try! uiRealm.write{
            uiRealm.add(boy)
            
        }
        
        let girl = Jiabin()
        girl.xingbie = "female"
        
        for i in 0...2 {
            let person = Haoma()
            person.ID = i
            girl.renshu.append(person)
        }
        try! uiRealm.write{
            uiRealm.add(girl)
            
        }
        self.currentResult.text = "I'm readly!!!"
        self.inputDataButton.isEnabled = false
        //print(uiRealm.configuration.fileURL!)
        updatePeopleLeft()
        
    }
    
    
    func updatePeopleLeft(){
        var text = ""
        lists = uiRealm.objects(Jiabin.self).filter("xingbie = 'male'")
        text = text + "男生：\(lists[0].renshu.count)"
        lists = uiRealm.objects(Jiabin.self).filter("xingbie = 'female'")
        text = text + " 女生：\(lists[0].renshu.count)"
        self.leftLabel.text = text
        
        
    }
    
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        self.imageResult.isHidden = true
        if motion == UIEventSubtype.motionShake && self.status == true && (self.BoyOrGirl.selectedSegmentIndex == 0 || self.BoyOrGirl.selectedSegmentIndex == 1) {
            playMusic()
        }
        
        
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        self.imageResult.isHidden = false
        if self.status == true {
            
            //music end
            if self.audioPlayer.isPlaying{
                self.audioPlayer.stop()
            }
            
             self.status = false
            
            if self.BoyOrGirl.selectedSegmentIndex == 0 {
                
                lists = uiRealm.objects(Jiabin.self).filter("xingbie = 'male'")
                let currentRenshu = lists[0].renshu.count
                if currentRenshu > 0 {
                    let n = Int(arc4random_uniform(UInt32(currentRenshu)))
                    self.currentResult.text = "\(lists[0].renshu[n].ID)"
                    self.imageResult.image = UIImage(named: "\(lists[0].renshu[n].ID)")
                    showAlert(message: "这是和你最有缘分的Ta哦！")
                    try! uiRealm.write{
                        uiRealm.delete(lists[0].renshu[n])
                    }
                    //self.leftLabel.text = "\(lists[0].renshu.count)"
                    updatePeopleLeft()
                } else {
                    self.currentResult.text = "来晚了哦~"
                    showAlert(message: "男生被抢光了，下次再来吧！")
                }
            }else if self.BoyOrGirl.selectedSegmentIndex == 1 {
                
                lists = uiRealm.objects(Jiabin.self).filter("xingbie = 'female'")
                let currentRenshu = lists[0].renshu.count
                if currentRenshu > 0 {
                    let n = Int(arc4random_uniform(UInt32(currentRenshu)))
                    self.currentResult.text = "\(lists[0].renshu[n].ID)"
                    self.imageResult.image = UIImage(named: "\(lists[0].renshu[n].ID)")
                    showAlert(message: "这是和你最有缘分的Ta哦！")
                    try! uiRealm.write{
                        uiRealm.delete(lists[0].renshu[n])
                    }
                    //self.leftLabel.text = "\(lists[0].renshu.count)"
                    updatePeopleLeft()
                } else {
                    self.currentResult.text = "来晚了哦~"
                    showAlert(message: "女生被抢光了，下次再来吧！")
                }
            }
            
           
           
            
        }
    }
    
    
    
    func showAlert(message:String){
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) in
            self.status = true
            
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    func playMusic(){
        let randomSongString = String(Int(arc4random_uniform(6)))
        let path = Bundle.main.url(forResource: randomSongString, withExtension: "mp3")
        self.audioPlayer = try! AVAudioPlayer(contentsOf: path!)
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.play()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updatePeopleLeft()

    }


}

