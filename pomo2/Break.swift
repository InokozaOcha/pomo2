//
//  Break.swift
//  pomo2
//
//  Created by Tanaka Kenta on 2020/01/14.
//  Copyright © 2020 PrestSQuare. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AudioToolbox

class Break: UIViewController{
    
    var breakCallBack:()
    
    var timer : Timer?
    
    var count = 0
    
    var adDuration = 0
    
    var timeStampEnd = 0
    var totalTime = 0
       
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        endBreakButton.layer.cornerRadius = 5
        
        let settings = UserDefaults.standard
        
        totalTime = settings.integer(forKey: "Bh")*3600 + settings.integer(forKey: "Bm")*60 + settings.integer(forKey: "Bs")
        
        timeStampEnd = Int(floor(NSDate().timeIntervalSince1970)) + totalTime
        
        let timerCount = totalTime - adDuration
        let setCounter : String = "次は\(settings.integer(forKey: "repeatRest")+1)セット目"
        countDownLabel.text =  labelText(timerCount)
        setCounterLabel.text = setCounter
        let nextTask = "task\(settings.integer(forKey: "repeatRest")+1)"
        nextTaskLabel.text = settings.string(forKey: nextTask)
        print(countDownLabel.text!)
        

        if let nowTimer = timer {
            if nowTimer.isValid == true {
                return
            }
        }
        
        
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(self.timerInterrupt(_:)),
            userInfo: nil,
            repeats: true
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(Running.viewWillEnterForeground(_:)),
            name: UIApplication.willEnterForegroundNotification,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(Running.viewDidEnterBackground(_:)),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var endBreakButton: UIButton!
    
    @IBAction func backRunnig(_ sender: Any) {
        /*
        if interstitial.isReady {
          interstitial.present(fromRootViewController: self)
        } else {
          print("Ad wasn't ready")
        }
        */
        
        let timeStampNow = NSDate().timeIntervalSince1970
        
        if let nowTimer = timer {
            if nowTimer.isValid == true {
                nowTimer.invalidate()
            }
        }
        
        var endAlert:UIAlertController
        var endAction = UIAlertAction()
        var cancelAction = UIAlertAction()
            endAlert = UIAlertController(title: "休憩おわりにする？", message: "次のタスクが始まります", preferredStyle: .alert)
            endAction = UIAlertAction(title: "Yes", style: .default, handler:{
                (action: UIAlertAction!) -> Void in
                
                print("OK")
                
                self.dismiss(animated: true)
            })
            cancelAction = UIAlertAction(title: "No", style: .default, handler:{
                (action: UIAlertAction!) -> Void in
                
                self.timeStampEnd = self.timeStampEnd + Int(floor(NSDate().timeIntervalSince1970 - timeStampNow)) + 1
                              // arlertMusic.stop()
                self.timer = Timer.scheduledTimer(
                    timeInterval: 1.0,
                    target: self,
                    selector: #selector(self.timerInterrupt(_:)),
                    userInfo: nil,
                    repeats: true
                )
                print("cancel")
            })
        
        endAlert.addAction(cancelAction)
        endAlert.addAction(endAction)
        
        present(endAlert, animated: true, completion: nil)
        
        
 
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBOutlet weak var countDownLabel: UILabel!
    
    @IBOutlet weak var setCounterLabel: UILabel!
    
    @IBOutlet weak var nextTaskLabel: UILabel!
    
    
    //カウントダウンラベルの表示
       func labelText(_ countInt:Int) -> String {
              var labelText = ""
              
              let h = countInt/3600
              let m = (countInt - h*3600)/60
              let s = countInt - h*3600 - m*60
              
                let m0 = NSString(format: "%02d", m) as String
                let s0 = NSString(format: "%02d", s) as String
              
              if h >= 1 {
                  labelText = "\(h):\(m0):\(s0)"
              } else if m >= 1 {
                  labelText = "\(m):\(s0)"
              } else {
                  labelText = "\(s)"
              }
              
              
              return labelText
          }
       
       //残り時間の計算＆出力
       func displayUpdate() -> Int {
           
           let timerValue = timeStampEnd  - adDuration
        
        /*
           if settings.integer(forKey: "totalTime") != timerValue {
               count = 0
               settings.setValue(timerValue,forKey:"totalTime")
               settings.synchronize()
           }
          */
           //print(timerValue)
           
           let remainCount = timerValue - Int(NSDate().timeIntervalSince1970)
           let h = remainCount/3600
           let m = (remainCount - h*3600)/60
           let s = remainCount - h*3600 - m*60
        
            let m0 = NSString(format: "%02d", m) as String
            let s0 = NSString(format: "%02d", s) as String
           
           
           if h >= 1 {
               countDownLabel.text = "\(h):\(m0):\(s0)"
           } else if m >= 1 {
               countDownLabel.text = "\(m):\(s0)"
           } else {
               countDownLabel.text = "\(s)"
           }
        
            
           
          
           return remainCount
       }
       
       //経過時間の処理
       @objc func timerInterrupt(_ timer:Timer) {
           count += 1
        /*
        if displayUpdate() == 60 {
            let soundIdRing:SystemSoundID = 1011
            AudioServicesPlaySystemSound(soundIdRing)
            AudioServicesPlaySystemSoundWithCompletion(soundIdRing) {
                AudioServicesPlaySystemSound(soundIdRing)
                AudioServicesPlaySystemSoundWithCompletion(soundIdRing) {
                    AudioServicesRemoveSystemSoundCompletion(soundIdRing)
                }
            }
        }
        */
        
        if displayUpdate() == 30 {
            //let soundIdRing2:SystemSoundID = 1521
            //let soundIdRing2:SystemSoundID = 1011
            //AudioServicesPlaySystemSound(soundIdRing2)
            
            // Shutter
            //var soundIdRing:SystemSoundID = 1108
             
            // bell
            var soundIdRing:SystemSoundID = 1005
                    
            // update
            //var soundIdRing:SystemSoundID = 1336
             
            if let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), nil, nil, nil){
                AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
                AudioServicesPlaySystemSound(soundIdRing)
            }
        }
            
           if displayUpdate() <= 0 {
               count = 0
               /*
               let soundIdRing:SystemSoundID = 1000  // new-mail.caf
               AudioServicesPlaySystemSound(soundIdRing)
               */
               
               // import this
               // create a sound ID, in this case its the tweet sound.
               //let systemSoundID: SystemSoundID = 1016
               // to play sound
               //AudioServicesPlaySystemSound (systemSoundID)
               
            //   let musicPath = Bundle.main.bundleURL.appendingPathComponent("cymbal.mp3")
               
             //  var arlertMusic = AVAudioPlayer()
         
               
               
               timer.invalidate()
               /*
               do {
                   arlertMusic = try AVAudioPlayer(contentsOf: musicPath, fileTypeHint: nil)
                   arlertMusic.numberOfLoops = -1
                   arlertMusic.play()
               } catch {
                   print("音でんで！")
               }
             
    */
               
                self.dismiss(animated: true){
                    print("EndBreak")
                }
          
               
           
               
           }
        
       }
    
    @objc func viewWillEnterForeground(_ notification: Notification?) {
         if (self.isViewLoaded && (self.view.window != nil)) {
             print("フォアグラウンド")
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["breakTime"])
         }
     }

    
    @objc func viewDidEnterBackground(_ notification: Notification?) {
        print("バックグラウンドああああああああああああああ")
        if (self.isViewLoaded && (self.view.window != nil)) {
            print("バックグラウンド")
            let restTime = Double(timeStampEnd -  Int(floor(NSDate().timeIntervalSince1970))-30)
            if (restTime > 0) {
                //　通知設定に必要なクラスをインスタンス化
                   let trigger: UNNotificationTrigger
                   let content = UNMutableNotificationContent()
                //   var notificationTime = DateComponents()

                   // トリガー設定
                /*
                   notificationTime.hour = 12
                   notificationTime.minute = 0
                   trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
                */
                
                print(restTime,"で３０秒まえ")
                    trigger = UNTimeIntervalNotificationTrigger(timeInterval: restTime, repeats: false)
                
                   // 通知内容の設定
                   content.title = "あと少しで休憩終わり！"
                   content.body = "準備してください"
                content.sound = UNNotificationSound.default

                   // 通知スタイルを指定
                   let request = UNNotificationRequest(identifier: "breakTime", content: content, trigger: trigger)
                   // 通知をセット
                   UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print("アプリ終了〜")
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["breakTime"])
    }
    
}
