//
//  FirstViewController.swift
//  pomo2
//
//  Created by Tanaka Kenta on 2020/01/14.
//  Copyright © 2020 PrestSQuare. All rights reserved.
//

import UIKit
import RealmSwift

class FirstViewController: UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource{
    var dataSourceHour = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]

    var dataSourceMinute = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59]

    var dataSourceSecond = [0,10,20,30,40,50]
    
    var dataSourceRepeat = [1,2,3,4,5,6,7,8,9,10]
    
    var rOk = 0
    
    var bOk = 0

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //let height:CGFloat = self.view.bounds.height
        let height:CGFloat = self.view.bounds.height
        let screenHeight = Int(UIScreen.main.bounds.size.height);
        print("height",height)
        print("screen",screenHeight)
        let hightConstant = Int(floor((height - 118-450)/2))
        print("margin",hightConstant)
        repeatBottom.constant = CGFloat(hightConstant)
        
        //print("testViewH",testView.layer.bounds.height)
        
        
        //view.backgroundColor = UIColor.init(red: 211/255, green: 244/255, blue: 213/255, alpha: 100/100)
        view.backgroundColor = UIColor(named: "backGroundGreen")
        //print(self.tabBarItem)
        UITabBar.appearance().tintColor = UIColor(named: "tabBar")
            //.badgeColor = UIColor.init(red: 211/255, green: 244/255, blue: 213/255, alpha: 100/100)
  
        for test in button {
            test.layer.cornerRadius = 5
        }

        self.runningTimer.delegate = self
        self.runningTimer.dataSource = self
        self.breakTimer.delegate = self
        self.breakTimer.dataSource = self
        self.repeatTimes.delegate = self
        self.repeatTimes.dataSource = self
        
        //let realm = try! Realm()
        //let result = realm.objects(Event.self)
        //print(result)
        
       // button.layer = 5.0
        
        //UserDefaults.standard.set(0, forKey: "Rh")
        let settings = UserDefaults.standard
        if  settings.integer(forKey: "repeat") == 0 {
            settings.register(defaults: [
                "Rh":0,
                "Rm":25,
                "Rs":0,
                "Bh":0,
                "Bm":5,
                "Bs":0,
                "repeat":4,
                "repeatRest":1,
                "task1":"",
                "task2":"",
                "task3":"",
                "task4":"",
                "task5":"",
                "task6":"",
                "task7":"",
                "task8":"",
                "task9":"",
                "task10":""
            ])
        }
        /*
        settings.setValue(0,forKey:"Rh")
         settings.setValue(0,forKey:"Rm")
         settings.setValue(0,forKey:"Rs")
         settings.setValue(0,forKey:"Bh")
         settings.setValue(0,forKey:"Bm")
        settings.setValue(0,forKey:"Bs")
        settings.setValue(0,forKey:"repeat")
        */
        settings.setValue(1,forKey:"repeatRest")
        settings.synchronize()
        
        
        let Rh = settings.integer(forKey: "Rh")
        let Rm = settings.integer(forKey: "Rm")
        let Rs = settings.integer(forKey: "Rs")
        let Bh = settings.integer(forKey: "Bh")
        let Bm = settings.integer(forKey: "Bm")
        let Bs = settings.integer(forKey: "Bs")
        let Cr = settings.integer(forKey: "repeat")
        
        if (Rh == 0 && Rm == 0 && Rs == 0) {
            rOk = 1
        } else {
            rOk = 0
        }
        
        if (Bh == 0 && Bm == 0 && Bs == 0) {
            bOk = 1
        } else {
            bOk = 0
        }
        
        if (bOk == 1 || rOk == 1) {
            startButton.backgroundColor = UIColor.init(red: 192/255, green: 192/255, blue: 192/255, alpha: 100/100)
        } else {
            startButton.backgroundColor = UIColor(named: "buttonGreen")
        }
        
        let hRow = dataSourceHour.count
       // let mRow = dataSourceMinute.count
        let sRow = dataSourceSecond.count
        let rRow = dataSourceRepeat.count
        
        for row in 0..<dataSourceMinute.count {
            if row < hRow {
                if dataSourceHour[row] == Rh {
                    runningTimer.selectRow(row, inComponent: 0, animated: true)
                }
                if dataSourceHour[row] == Bh {
                    breakTimer.selectRow(row, inComponent: 0, animated: true)
                }
            }
            
            if dataSourceMinute[row] == Rm {
                runningTimer.selectRow(row, inComponent: 1, animated: true)
            }
            
            if dataSourceMinute[row] == Bm {
                breakTimer.selectRow(row, inComponent: 1, animated: true)
            }
            
            if row < sRow {
                if dataSourceSecond[row] == Rs {
                    runningTimer.selectRow(row, inComponent: 2, animated: true)
                }
                
                if dataSourceSecond[row] == Bs {
                    breakTimer.selectRow(row, inComponent: 2, animated: true)
                }
                
            }
            if row < rRow {
                if dataSourceRepeat[row] == Cr {
                    repeatTimes.selectRow(row, inComponent: 0, animated: true)
                }
            }
            
          
            
            
        }
    }
    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func goRunning(_ sender: Any) {
        if(rOk != 1 && bOk != 1) {
            
            if #available(iOS 10.0, *) {
                // iOS 10
                let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
                    if error != nil {
                        return
                    }

                    if granted {
                        print("通知許可")

                        let center = UNUserNotificationCenter.current()
                        center.delegate = self as? UNUserNotificationCenterDelegate

                    } else {
                        print("通知拒否")
                    }
                })

            } else {
                // iOS 9以下
                let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(settings)
            }
            
            let settings = UserDefaults.standard
            settings.setValue(1,forKey:"repeatRest")
            settings.synchronize()
            let storyboard: UIStoryboard = self.storyboard!
            // ②遷移先ViewControllerのインスタンス取得
            let nextView = storyboard.instantiateViewController(withIdentifier: "Running") as! Running
            nextView.modalPresentationStyle = .fullScreen
            // ③画面遷移
            self.present(nextView, animated: true, completion: nil)
        }
    }
    
    @IBAction func goSettingTask(_ sender: Any) {
            let storyboard: UIStoryboard = self.storyboard!
            // ②遷移先ViewControllerのインスタンス取得
            let nextView = storyboard.instantiateViewController(withIdentifier: "Settingtask")
            nextView.modalPresentationStyle = .fullScreen
            //view.backgroundColor = UIColor.init(red: 230/255, green: 255/255, blue: 230/255, alpha: 0/100)
            // ③画面遷移
            self.present(nextView, animated: true, completion: nil)
    }
    // @IBOutlet weak var goRunningButton: UIButton!
    
    @IBOutlet weak var runningTimer: UIPickerView!
    
    
    @IBOutlet weak var breakTimer: UIPickerView!
    
    
    @IBOutlet weak var repeatTimes: UIPickerView!
    
    
    @IBOutlet var button: [UIButton]!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 1{
        return 3
        } else if pickerView.tag == 2{
        return 3
        } else if pickerView.tag == 3{
        return 1
        } else {
        return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            switch component {
                case 0:
                    return dataSourceHour.count
                case 1:
                    return dataSourceMinute.count
                case 2:
                    return dataSourceSecond.count
                default:
                    return 0
            }
        } else if pickerView.tag == 2{
            switch component {
                case 0:
                    return dataSourceHour.count
                case 1:
                    return dataSourceMinute.count
                case 2:
                    return dataSourceSecond.count
                default:
                    return 0
            }
        } else if pickerView.tag == 3{
        return dataSourceRepeat.count
        } else {
        return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1{
            switch component {
            case 0:
                return String(dataSourceHour[row])
            case 1:
                return String(dataSourceMinute[row])
            case 2:
                return String(dataSourceSecond[row])
            default:
                return "error1"
            }
        } else if pickerView.tag == 2{
            switch component {
            case 0:
                return String(dataSourceHour[row])
            case 1:
                return String(dataSourceMinute[row])
            case 2:
                return String(dataSourceSecond[row])
            default:
                return "error2"
            }
        } else if pickerView.tag == 3{
            return String(dataSourceRepeat[row])
        } else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let settings = UserDefaults.standard
        
        if pickerView.tag == 1 {
            switch component {
                case 0:
                    settings.setValue(dataSourceHour[row],forKey:"Rh")
                    settings.synchronize()
                case 1:
                    settings.setValue(dataSourceMinute[row],forKey:"Rm")
                    settings.synchronize()
                case 2:
                    settings.setValue(dataSourceSecond[row],forKey:"Rs")
                    settings.synchronize()
                default:
                    print("これが返ることはないねんけどな")
            }
            
            if ((settings.integer(forKey: "Rh") == 0 && settings.integer(forKey: "Rm") == 0 && settings.integer(forKey: "Rs") == 0)) {
                rOk = 1
            } else {
                rOk = 0
            }
            
            if (bOk == 1 || rOk == 1) {
                startButton.backgroundColor = UIColor.init(red: 192/255, green: 192/255, blue: 192/255, alpha: 100/100)
            } else {
                startButton.backgroundColor = UIColor(named: "buttonGreen")
            }
            
        } else if pickerView.tag == 2 {
            switch component {
                case 0:
                    settings.setValue(dataSourceHour[row],forKey:"Bh")
                    settings.synchronize()
                case 1:
                    settings.setValue(dataSourceMinute[row],forKey:"Bm")
                    settings.synchronize()
                case 2:
                    settings.setValue(dataSourceSecond[row],forKey:"Bs")
                    settings.synchronize()
                default:
                    print("これが返ることはないねんけどな")
            }
            
            if ((settings.integer(forKey: "Bh") == 0 && settings.integer(forKey: "Bm") == 0 && settings.integer(forKey: "Bs") == 0)) {
                bOk = 1
            } else {
                bOk = 0
            }
            
            if (bOk == 1 || rOk == 1) {
                startButton.backgroundColor = UIColor.init(red: 192/255, green: 192/255, blue: 192/255, alpha: 100/100)
            } else {
                startButton.backgroundColor = UIColor(named: "buttonGreen")
            }
            
            
        } else if pickerView.tag == 3 {
            switch component {
                case 0:
                    settings.setValue(dataSourceRepeat[row],forKey:"repeat")
                    settings.synchronize()
                default:
                    print("これが返ることはないねんけどな")
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.rotationChange(notification:)),
                name:UIDevice.orientationDidChangeNotification,
              object: nil)
        print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
    }
    
    @objc
       func rotationChange(notification: NSNotification){
           setLabel()
       }
    func setLabel(){
        switch UIDevice.current.model {
        case "iPnone" :
        print("これはiPhone")
            break
        case "iPad" :
            print("これはiPad")
            let height:CGFloat = self.view.bounds.width
            let screenHeight = Int(UIScreen.main.bounds.size.width);
            print("height",height)
            print("screen",screenHeight)
            let hightConstant = Int(floor((height - 118-450)/2))
            print("margin",hightConstant)
            repeatBottom.constant = CGFloat(hightConstant)
            
            break
        default:
            break
        }
    
        
        
    }
 
    
    @IBOutlet weak var repeatBottom: NSLayoutConstraint!
    
    @IBOutlet weak var testView: UIView!
    
}

