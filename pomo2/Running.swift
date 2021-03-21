//
//  Running.swift
//  pomo2
//
//  Created by Tanaka Kenta on 2020/01/14.
//  Copyright © 2020 PrestSQuare. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift
import GoogleMobileAds
import AudioToolbox

class Running: UIViewController , GADRewardBasedVideoAdDelegate{
    var rewardItem = 0
    
    var timeStampEnd = 0
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        rewardItem = 1
        return
    }
    
    
    let backmusicPath = Bundle.main.bundleURL.appendingPathComponent("nc97718.wav")
    var backmusicPlayer:AVAudioPlayer = AVAudioPlayer()
    
 
    var totalTime = 0
    
    var timer : Timer?
    var adTimer : Timer?
    
    var dateNow:String?
    var taskTitle:String?
    
    var saveCount = 0
    
    var count = 0
    
    var adTime = 0
    
    var remainCount = 0
    
    var adStart:Date = Date()
    var adDuration:Int = 0
    
    var soundCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //realmReset()
        //view.backgroundColor = UIColor.init(red: 211/255, green: 244/255, blue: 213/255, alpha: 100/100)
        view.backgroundColor = UIColor(named: "backGroundGreen")
        for test in button {
            test.layer.cornerRadius = 5
        }
        
        
        
        
        let settings = UserDefaults.standard
        totalTime = settings.integer(forKey: "Rh")*3600 + settings.integer(forKey: "Rm")*60 + settings.integer(forKey: "Rs")
        timeStampEnd = Int(floor(NSDate().timeIntervalSince1970)) + totalTime
        
        let timerCount = settings.integer(forKey: "Rh")*3600 + settings.integer(forKey: "Rm")*60 + settings.integer(forKey: "Rs")
        let setCounter : String = "\(settings.integer(forKey: "repeatRest"))セット目"
        countDownLabel.text =  labelText(timerCount)
        let nextRepeat = settings.integer(forKey: "repeatRest")
        let nextTitleNo = "task\(nextRepeat)"
        taskTitle = settings.string(forKey: nextTitleNo)
        titleLabel.text = taskTitle
        //print(taskTitle ?? "aaaaaaaaaaaaaaaaa")
        titleLabel.text = taskTitle
        setCounterLabel.text = setCounter

        if let nowTimer = timer {
            if nowTimer.isValid == true {
                return
            }
        }
        
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
       
        
        
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(self.timerInterrupt(_:)),
            userInfo: nil,
            repeats: true
        )
        

        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet var button: [UIButton]!
    
    
    
    
    @IBAction func backSetting(_ sender: Any) {
        let timeStampNow = NSDate().timeIntervalSince1970
        if let nowTimer = timer {
                   if nowTimer.isValid == true {
                       nowTimer.invalidate()
                   }
               }
               let settings = UserDefaults.standard
               var endAlert:UIAlertController
               var endAction = UIAlertAction()
               var cancelAction = UIAlertAction()
                   endAlert = UIAlertController(title: "設定画面に戻っていいですか？", message: "タスクの設定もリセットされます", preferredStyle: .alert)
                   endAction = UIAlertAction(title: "Yes", style: .default, handler:{
                       (action: UIAlertAction!) -> Void in
                                    //      arlertMusic.stop()
                    self.count = -100
                       print("OK")
                       settings.setValue("",forKey:"task1")
                       settings.setValue("",forKey:"task2")
                       settings.setValue("",forKey:"task3")
                       settings.setValue("",forKey:"task4")
                       settings.setValue("",forKey:"task5")
                       settings.setValue("",forKey:"task6")
                       settings.setValue("",forKey:"task7")
                       settings.setValue("",forKey:"task8")
                       settings.setValue("",forKey:"task9")
                       settings.setValue("",forKey:"task10")
                       
                       self.dismiss(animated: true)
                   })
                   cancelAction = UIAlertAction(title: "No", style: .default, handler:{
                       (action: UIAlertAction!) -> Void in
                                     // arlertMusic.stop()
                        
                    self.timeStampEnd = self.timeStampEnd + Int(floor(NSDate().timeIntervalSince1970 - timeStampNow)) + 1
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
    
    @IBAction func goBreak(_ sender: Any) {
        let timeStampNow = NSDate().timeIntervalSince1970
        self.saveCount = self.count
        if let nowTimer = timer {
            if nowTimer.isValid == true {
                nowTimer.invalidate()
            }
        }
        let settings = UserDefaults.standard
        var endAlert:UIAlertController
        var endAction = UIAlertAction()
        var cancelAction = UIAlertAction()
        if settings.integer(forKey: "repeat") == settings.integer(forKey: "repeatRest") {
            endAlert = UIAlertController(title: "お疲れさま！", message: "まだ時間あるけど設定画面に戻りますか？", preferredStyle: .alert)
            endAction = UIAlertAction(title: "Yes", style: .default, handler:{
                (action: UIAlertAction!) -> Void in
                              //    arlertMusic.stop()
                //self.saveCount = self.count
                if self.count != -100 {
                    self.saveEvent()
                }
                print("OK")
                settings.setValue("",forKey:"task1")
                settings.setValue("",forKey:"task2")
                settings.setValue("",forKey:"task3")
                settings.setValue("",forKey:"task4")
                settings.setValue("",forKey:"task5")
                settings.setValue("",forKey:"task6")
                settings.setValue("",forKey:"task7")
                settings.setValue("",forKey:"task8")
                settings.setValue("",forKey:"task9")
                settings.setValue("",forKey:"task10")
                
                self.dismiss(animated: true)
            })
            cancelAction = UIAlertAction(title: "No", style: .default, handler:{
                (action: UIAlertAction!) -> Void in
                         //      arlertMusic.stop()
                self.timeStampEnd = self.timeStampEnd + Int(floor(NSDate().timeIntervalSince1970 - timeStampNow)) + 1
                self.timer = Timer.scheduledTimer(
                    timeInterval: 1.0,
                    target: self,
                    selector: #selector(self.timerInterrupt(_:)),
                    userInfo: nil,
                    repeats: true
                )
                print("cancel")
            })
        } else {
            endAlert = UIAlertController(title: "まだ時間あるけど…", message: "休憩しますか？\n広告の後、休憩に入ります", preferredStyle: .alert)
            endAction = UIAlertAction(title: "Yes", style: .default, handler:{
                (action: UIAlertAction!) -> Void in
                
                if self.count != -100 {
                    self.saveEvent()
                }
                
                if GADRewardBasedVideoAd.sharedInstance().isReady == true {
                  GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
                }else {
                    print("Ad wasn't ready")
                    let storyboard: UIStoryboard = self.storyboard!
                    let nextView = storyboard.instantiateViewController(withIdentifier: "Break") as! Break
                    nextView.modalPresentationStyle = .fullScreen
                    // ③画面遷移
                    self.present(nextView, animated: true, completion: nil)
                }
                
                
                             //      arlertMusic.stop()let storyboard: UIStoryboard = self.storyboard!
                
            })
            cancelAction = UIAlertAction(title: "No", style: .default, handler:{
                (action: UIAlertAction!) -> Void in
                         //      arlertMusic.stop()
                self.timeStampEnd = self.timeStampEnd + Int(floor(NSDate().timeIntervalSince1970 - timeStampNow)) + 1
                self.timer = Timer.scheduledTimer(
                    timeInterval: 1.0,
                    target: self,
                    selector: #selector(self.timerInterrupt(_:)),
                    userInfo: nil,
                    repeats: true
                )
                
                print("cancel")
            })
        }
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
        //let settings = UserDefaults.standard
        
        //let timerValue = settings.integer(forKey: "Rh")*3600 + settings.integer(forKey: "Rm")*60 + settings.integer(forKey: "Rs")
     
        remainCount = timeStampEnd - Int(NSDate().timeIntervalSince1970)
        //let remainCount = timerValue - count
        
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
    
    @objc func adTimerInterrupt(_ adTimer:Timer) {
        adTime += 1
        print("adTime:",adTime)
    }
    //経過時間の処理
    @objc func timerInterrupt(_ timer:Timer) {
        count = totalTime - remainCount + 1
        
        if displayUpdate() == 0 {
            timer.invalidate()
            
            let audioSession = AVAudioSession.sharedInstance()
            let volume = audioSession.outputVolume
            print("aakfoewkgkwojkgewkgopkewpkogpweo::::::::::::::",volume)
            if(volume != 0.0) {
                do {
                    backmusicPlayer = try AVAudioPlayer(contentsOf: backmusicPath, fileTypeHint: nil)
                    backmusicPlayer.numberOfLoops = -1
                    backmusicPlayer.play()
                } catch {
                    
                }
            }
            
            
            vibrate()
        }
        
        if displayUpdate() <= 0  {
            
            let settings = UserDefaults.standard
            
            saveCount = settings.integer(forKey: "Rh")*3600 + settings.integer(forKey: "Rm")*60 + settings.integer(forKey: "Rs")
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
      
            
            
            
            
            
            
            /*
            do {
                arlertMusic = try AVAudioPlayer(contentsOf: musicPath, fileTypeHint: nil)
                arlertMusic.numberOfLoops = -1
                arlertMusic.play()
            } catch {
                print("音でんで！")
            }
 */

            
            let a = settings.integer(forKey: "repeat")
            let b = settings.integer(forKey: "repeatRest")
            //print(a,"=",b)
            var endAlert:UIAlertController
            var endAction = UIAlertAction()
            if(a == b) {
          
                endAlert = UIAlertController(title: "お疲れさま！", message: "設定画面に戻ります", preferredStyle: .alert)
                endAction = UIAlertAction(title: "OK", style: .default, handler:{
                    (action: UIAlertAction!) -> Void in
                  //      arlertMusic.stop()
                    if self.count != -100 {
                        self.saveEvent()
                    }
                    self.backmusicPlayer.stop()
                        print("OK")
                    self.dismiss(animated: true)
                })
                
               
                /*
                let endAlert = UIAlertController(title: "お疲れさま", message: "設定にもどるで", preferredStyle: .alert)
                
                let endAction = UIAlertAction(title: "OK", style: .default, handler:{
                    (action: UIAlertAction!) -> Void in
                  //      arlertMusic.stop()
                        print("OK")
                    self.dismiss(animated: true)
                })
                endAlert.addAction(endAction)
                present(endAlert, animated: true, completion: nil)
 */
                
            } else {
                endAlert = UIAlertController(title: "終了です！", message: "広告の後、休憩に入ります", preferredStyle: .alert)
                endAction = UIAlertAction(title: "OK", style: .default, handler:{
                    (action: UIAlertAction!) -> Void in
                    if self.count != -100 {
                        self.saveEvent()
                    }
                  //      arlertMusic.stop()
                    self.backmusicPlayer.stop()
                        print("OK")
                        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
                          GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
                        }else {
                            print("Ad wasn't ready")
                            // ①storyboardのインスタンス取得
                                 let storyboard: UIStoryboard = self.storyboard!
                                 
                                        // ②遷移先ViewControllerのインスタンス取得
                                 let nextView = storyboard.instantiateViewController(withIdentifier: "Break") as! Break
                                 //nextView.breakCallBack =  { self.callBack() }()
                                 nextView.modalPresentationStyle = .fullScreen
                            
                                        // ③画面遷移
                                 self.present(nextView, animated: true, completion: nil)
                                 //self.performSegue(withIdentifier: "goBreakTime", sender: self)

                        }
                    
                        
                      
                    
                        
                })
                
    
                /*
                let alertController = UIAlertController(title: "終了", message: "時間やで！", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler:{
                    (action: UIAlertAction!) -> Void in
                  //      arlertMusic.stop()
                        print("OK")
                    
                      
                    
                        // ①storyboardのインスタンス取得
                        let storyboard: UIStoryboard = self.storyboard!
                        
                               // ②遷移先ViewControllerのインスタンス取得
                        let nextView = storyboard.instantiateViewController(withIdentifier: "Break") as! Break
                        //nextView.breakCallBack =  { self.callBack() }()
                        nextView.modalPresentationStyle = .fullScreen
                   
                               // ③画面遷移
                        self.present(nextView, animated: true, completion: nil)
                        //self.performSegue(withIdentifier: "goBreakTime", sender: self)
                })
                
                alertController.addAction(defaultAction)
                
                present(alertController, animated: true, completion: nil)
                */
            }
            
            endAlert.addAction(endAction)
            //backmusicPlayer.stop()
            present(endAlert, animated: true, completion: nil)
            //print("遷移後に変更できる？")
            
        
            
        }
    }
    
    @objc func timerStop(_ timer:Timer) {
        timer.invalidate()
        let settings = UserDefaults.standard
        
        let timerValue = settings.integer(forKey: "Rh")*3600 + settings.integer(forKey: "Rm")*60 + settings.integer(forKey: "Rs")
        
  
        
        let h = timerValue/3600
        let m = (timerValue - h*3600)/60
        let s = timerValue - h*3600 - m*60
        
        let m0 = NSString(format: "%02d", m) as String
        let s0 = NSString(format: "%02d", s) as String
        
        if h >= 1 {
            countDownLabel.text = "\(h):\(m0):\(s0)"
        } else if m >= 1 {
            countDownLabel.text = "\(m):\(s0)"
        } else {
            countDownLabel.text = "\(s)"
        }
        
    }
    
    @objc func timerStopSimple(_ timer:Timer) {
        timer.invalidate()
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        
        //GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
        //GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),withAdUnitID: "ca-app-pub-2854457128650096~1148738361")
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),withAdUnitID: "ca-app-pub-2854457128650096/2188990319")
        
        count = 0
        
        dateNow = getToday(format:"yyyy/MM/dd")
        //print(dateNow ?? "out")
        let settings = UserDefaults.standard
        
        
        timeStampEnd = Int(floor(NSDate().timeIntervalSince1970)) + settings.integer(forKey: "Rh")*3600 + settings.integer(forKey: "Rm")*60 + settings.integer(forKey: "Rs")
       
        
        _ = displayUpdate()
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
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        let settings = UserDefaults.standard
        
        let timerValue = settings.integer(forKey: "Rh")*3600 + settings.integer(forKey: "Rm")*60 + settings.integer(forKey: "Rs")
        //let remainCount = timerValue - count
        
        let h = timerValue/3600
        let m = (timerValue - h*3600)/60
        let s = timerValue - h*3600 - m*60
        
        let m0 = NSString(format: "%02d", m) as String
        let s0 = NSString(format: "%02d", s) as String
        
        taskTitle = titleLabel.text
        print("のこり時間",count)
        print("今のタスク",taskTitle ?? "aaa")
        
        print("アプリ終了〜")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["uuid","breakTime5"])
        
        
        
        
        if h >= 1 {
            countDownLabel.text = "\(h):\(m0):\(s0)"
        } else if m >= 1 {
            countDownLabel.text = "\(m):\(s0)"
        } else {
            countDownLabel.text = "\(s)"
        }
        
        let nextRepeat = settings.integer(forKey: "repeatRest") + 1
        let nextTitleNo = "task\(nextRepeat)"

        settings.setValue(nextRepeat, forKey:"repeatRest")
        settings.synchronize()
        setCounterLabel.text = "\(nextRepeat)セット目"
        titleLabel.text = settings.string(forKey: nextTitleNo)
        
    }
    
    func callBack() {
        print("戻ってきたで！")
        //viewDidLoad()
    }
    
    @IBOutlet weak var titleLabel: UILabel!

    func getToday(format:String = "yyyy/MM/dd HH:mm:ss") -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: now as Date)
    }
    
    //DB書き込み処理
    @objc func saveEvent(){
        print("データ書き込み開始")
        
            let time:Int = Int(NSDate().timeIntervalSince1970)
            let timeStart = time - saveCount
            let realm = try! Realm()

            try! realm.write {
                //日付表示の内容とスケジュール入力の内容が書き込まれる。
                let Events = [Event(value: [
                    "date": dateNow ?? "",
                    "event": taskTitle ?? "",
                    "timerCount": saveCount,
                    "timeStamp": timeStart
                ])]
                realm.add(Events)
                print("データ書き込み中")
            }

        print("データ書き込み完了")

        //前のページに戻る
        //dismiss(animated: true, completion: nil)

    }
    
    func realmReset() {
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {}
        })
        Realm.Configuration.defaultConfiguration = config
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
      print("Reward based video ad has completed.")
        print("広告終了！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！")
        let settings = UserDefaults.standard
        let breakTime = settings.integer(forKey: "Bh")*3600 + settings.integer(forKey: "Bm")*60 + settings.integer(forKey: "Bs")
        adDuration = Int(Date().timeIntervalSince(adStart))
        print(adDuration)
        if (adDuration <= breakTime ) {
            if (rewardItem == 1 ){
                if let nowTimer = timer {
                   if nowTimer.isValid == true {
                       nowTimer.invalidate()
                   }
                }
                let settings = UserDefaults.standard
                settings.setValue(settings.integer(forKey: "repeatRest" ) - 1, forKey:"repeatRest")
                settings.synchronize()
                rewardItem = 0
                let storyboard: UIStoryboard = self.storyboard!
                let nextView = storyboard.instantiateViewController(withIdentifier: "Break") as! Break
                nextView.modalPresentationStyle = .fullScreen
                nextView.adDuration = adDuration
                // ③画面遷移
                self.present(nextView, animated: true, completion: nil)
            }
            
        }
        
        
        
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
        
        adStart = Date()
        
        print("adtimer Start!!!!!!!!!!!.")
    }
    

  func vibrate() {
        
       // AudioServicesPlaySystemSound(SystemSoundID(1011))
        let soundIdRing:SystemSoundID = kSystemSoundID_Vibrate
       /*
        
            //通知音を再生終了時のコールバックを指定
        AudioServicesAddSystemSoundCompletion(soundIdRing, nil, nil, { (soundIdRing, nil) -> Void in
                //再生終了後に実行したいコード
                AudioServicesRemoveSystemSoundCompletion(soundIdRing)

            }, nil)
        

        if soundCounter > 3 {
            AudioServicesRemoveSystemSoundCompletion(soundIdRing)
        }
        
 */
        //音を鳴らす
        AudioServicesPlaySystemSound(soundIdRing)

    /*
        AudioServicesPlaySystemSoundWithCompletion(soundIdRing) {
              //サウンドが鳴り終わった後の処理を記述
            self.soundCounter = self.soundCounter + 1
            if (self.soundCounter < 5) {
                AudioServicesPlaySystemSound(soundIdRing)
            } else {
                AudioServicesRemoveSystemSoundCompletion(soundIdRing)
            }
        }
    */
        AudioServicesPlaySystemSoundWithCompletion(soundIdRing) {
            AudioServicesPlaySystemSound(soundIdRing)
            AudioServicesPlaySystemSoundWithCompletion(soundIdRing) {
                AudioServicesPlaySystemSound(soundIdRing)
            }
        }
        
    }
    
    @objc func viewWillEnterForeground(_ notification: Notification?) {
        if (self.isViewLoaded && (self.view.window != nil)) {
            print("フォアグラウンド")
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["uuid","breakTime5"])
        }
    }

    @objc func viewDidEnterBackground(_ notification: Notification?) {
        if (self.isViewLoaded && (self.view.window != nil)) {
            print("バックグラウンド")
            
            let restTime = Double(timeStampEnd -  Int(floor(NSDate().timeIntervalSince1970))-300)
                       if (restTime > 0) {
                           //　通知設定に必要なクラスをインスタンス化
                              let trigger5: UNNotificationTrigger
                              let content5 = UNMutableNotificationContent()
                           //   var notificationTime = DateComponents()

                              // トリガー設定
                           /*
                              notificationTime.hour = 12
                              notificationTime.minute = 0
                              trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
                           */
                           
                           print(restTime,"で３０秒まえ")
                               trigger5 = UNTimeIntervalNotificationTrigger(timeInterval: restTime, repeats: false)
                           
                              // 通知内容の設定
                              content5.title = "あと5分"
                              content5.body = "がんばって！"
                           content5.sound = UNNotificationSound.default

                              // 通知スタイルを指定
                              let request = UNNotificationRequest(identifier: "breakTime5", content: content5, trigger: trigger5)
                              // 通知をセット
                              UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                       }
            
            
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
            
            print(Double(timeStampEnd -  Int(floor(NSDate().timeIntervalSince1970))),"にタイマー終了です")
                trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(timeStampEnd -  Int(floor(NSDate().timeIntervalSince1970))), repeats: false)
            
               // 通知内容の設定
               content.title = "終了です！"
               content.body = "休憩に入ります"
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "nc97718.wav"))
    
               content.sound = UNNotificationSound.default
               // 通知スタイルを指定
               let request = UNNotificationRequest(identifier: "uuid", content: content, trigger: trigger)
               // 通知をセット
               UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
    @objc func applicationWillTerminate(_ notification: Notification?) {
        let triggerEnd: UNNotificationTrigger
        let contentEnd = UNMutableNotificationContent()
        triggerEnd = UNTimeIntervalNotificationTrigger(timeInterval:0.5, repeats: false)
        contentEnd.title = "アプリ終了！"
        contentEnd.body = "アプリが終了されたので、タイマーがリセットされました"
        
        let request = UNNotificationRequest(identifier: "end", content: contentEnd, trigger: triggerEnd)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    
    
    

}
