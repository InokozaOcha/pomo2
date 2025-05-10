//
//  SecondViewController.swift
//  pomo2
//
//  Created by Tanaka Kenta on 2020/01/14.
//  Copyright © 2020 PrestSQuare. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import RealmSwift

//ディスプレイサイズ取得
let w = UIScreen.main.bounds.size.width
let h = UIScreen.main.bounds.size.height

class SecondViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    
    var todo = [Event] ()
    
    var checkMonth = 2
    var checkMonthCheck = 0
    
    var totalCount = 0
    
    var daPreserve = ""
    
    var Cy = 0
    
    @IBOutlet weak var topSafeCover: UIView!
    @IBOutlet weak var totalTimeHight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var totalTimeView: UIView!
    
    @IBOutlet weak var pomoLabel: UILabel!
    //スケジュール内容
    let labelDate = UILabel(frame: CGRect(x: 5, y: 580, width: 400, height: 50))
    //「主なスケジュール」の表示
    //let labelTitle = UILabel(frame: CGRect(x: 0, y: 530, width: 180, height: 50))
    //カレンダー部分
    
    var dateView = FSCalendar(frame: CGRect(x: 0, y: 30, width: w, height: 420))
    
    //日付の表示
 //   let Date = UILabel(frame: CGRect(x: 5, y: 430, width: 200, height: 100))
    
    override func viewWillLayoutSubviews() {
        let safeAreaFrame = self.view.safeAreaLayoutGuide.layoutFrame
        let safeAreaTop = safeAreaFrame.origin.y
        print("safeAreaTop",safeAreaTop)
        dateView.frame.origin.y = safeAreaTop
        let constraint1 = NSLayoutConstraint(item: dateView, attribute: .bottom, relatedBy: .equal, toItem: totalTime, attribute: .top, multiplier: 1.0, constant: 0.0)
        let constraint2 = NSLayoutConstraint(item: dateView, attribute: .bottom, relatedBy: .equal, toItem: totalTimeView, attribute: .top, multiplier: 1.0, constant: 0.0)
        topSafeCover.frame.origin.y = 0
        
        
        view.addConstraints([constraint1,constraint2])
        
        //print("totalTime.frame.origin.y",totalTimeHight.constant)
        //totalTimeHight.constant = safeAreaTop + 400
        Cy = Int(safeAreaTop+400)
   
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let calendarH = Int(h*0.6)
        dateView = FSCalendar(frame: CGRect(x: 0, y: 30, width: Int(w), height: calendarH))
        
        let screenWidth:CGFloat = UIScreen.main.bounds.size.width
        let screenHeight:CGFloat = UIScreen.main.bounds.size.height * 0.6
        // ラベルのサイズを設定
        dateView.setScope(.month, animated: false)

        dateView.frame = CGRect(x:0, y:30,
                                    width:screenWidth, height:screenHeight)
        
        //カレンダー設定
        self.dateView.dataSource = self
        self.dateView.delegate = self
        //let aaa = Date()
        self.dateView.scrollDirection = .vertical
        //self.dateView.appearance.headerDateFormat = "YYYY M"
        self.dateView.appearance.headerTitleColor = UIColor.init(red: 230/255, green: 0/255, blue: 0/255, alpha: 90/100)
        self.dateView.appearance.weekdayTextColor = UIColor.init(red: 230/255, green: 0/255, blue: 0/255, alpha: 90/100)
        
        self.dateView.appearance.selectionColor = UIColor(named: "buttonGreen")
        self.dateView.appearance.eventDefaultColor = UIColor(named: "buttonGreen")
        self.dateView.appearance.eventSelectionColor = UIColor(named: "buttonGreen")
        self.tableView.separatorColor = .lightGray
        
        self.tableView.rowHeight = 60;
        
  
        
        self.dateView.today = Date()
        self.dateView.tintColor = .red

        self.view.backgroundColor = UIColor(named: "backGroundPink")
        dateView.backgroundColor = UIColor(named: "backGroundPink")
        tableView.backgroundColor = UIColor(named: "backGroundPink")
   
        view.addSubview(dateView)
        
        print("aaaaaaaaaaaaaaa",Date())
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let m = String(format: "%02d", month)
        let d = String(format: "%02d", day)
        
        let realm = try! Realm()
        var result = realm.objects(Event.self)
        let da = "\(year)/\(m)/\(d)"
        daPreserve = da
        print("dadadadadadadada",da)
            result = result.filter("date = '\(da)'")
            
            todo.removeAll()

            //print(result)
            for ev in result {
                if ev.date == da {
                    labelDate.text = ev.event
                    labelDate.textColor = .black
                    //view.addSubview(labelDate)
                    todo.append(ev)
                    
                }
            }
            print("初期設定todo：",todo)
            tableView.reloadData()
            _ = totalCountUpdate()
     
       }

       fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
       fileprivate lazy var dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           return formatter
       }()

       // 祝日判定を行い結果を返すメソッド
       func judgeHoliday(_ date : Date) -> Bool {
           //祝日判定用のカレンダークラスのインスタンス
           let tmpCalendar = Calendar(identifier: .gregorian)

           // 祝日判定を行う日にちの年、月、日を取得
           let year = tmpCalendar.component(.year, from: date)
           let month = tmpCalendar.component(.month, from: date)
           let day = tmpCalendar.component(.day, from: date)

           let holiday = CalculateCalendarLogic()

           return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
       }

       // date型 -> 年月日をIntで取得
       func getDay(_ date:Date) -> (Int,Int,Int){
           let tmpCalendar = Calendar(identifier: .gregorian)
           let year = tmpCalendar.component(.year, from: date)
           let month = tmpCalendar.component(.month, from: date)
           let day = tmpCalendar.component(.day, from: date)
            print(month)
           return (year,month,day)
       }
    

       //曜日判定
       func getWeekIdx(_ date: Date) -> Int{
           let tmpCalendar = Calendar(identifier: .gregorian)
           return tmpCalendar.component(.weekday, from: date)
       }
  
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("Changed")
        print("ss") // Do something
        let formatter = DateFormatter()
        //formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "M", options: 0, locale: Locale(identifier: "ja_JP"))
        formatter.dateFormat = "M"
        checkMonth = Int(formatter.string(from: calendar.currentPage)) ?? 0
        //let nowM = Int(formatter.string(from: date))
        print(checkMonth)
    }

       // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) ->
        UIColor? {
           //祝日判定をする
            
            let formatter = DateFormatter()
          
            formatter.dateFormat = "yyyyMMdd"
            let pageM = Int(formatter.string(from: Date()))
            let nowM = Int(formatter.string(from: date))
         
            print(nowM!,":",pageM!)
            if nowM! == pageM {
                return UIColor.white
            }
            
            if self.judgeHoliday(date) {
                return UIColor.init(red: 53/255, green: 127/255, blue: 61/255, alpha: 100/100)
            }
                //土日の判定
                let weekday = self.getWeekIdx(date)
                if weekday == 1 {
                    return UIColor.red
                }
                else if weekday == 7 {
                    return UIColor.blue
                }

                return UIColor.init(red: 80/255, green: 80/255, blue: 80/255, alpha: 100/100)
            
           
       }
    
    
    //カレンダー処理(スケジュール表示処理)
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){

        let tmpDate = Calendar(identifier: .gregorian)
        let year = tmpDate.component(.year, from: date)
        let month = tmpDate.component(.month, from: date)
        let day = tmpDate.component(.day, from: date)
        let m = String(format: "%02d", month)
        let d = String(format: "%02d", day)

        let da = "\(year)/\(m)/\(d)"
        daPreserve = da

        //スケジュール取得
        let realm = try! Realm()
        var result = realm.objects(Event.self)
        result = result.filter("date = '\(da)'")
        
        todo.removeAll()

        //print(result)
        for ev in result {
            if ev.date == da {
                labelDate.text = ev.event
                labelDate.textColor = .black
                //view.addSubview(labelDate)
                todo.append(ev)
                totalCount = totalCount + ev.timerCount
            }
        }
        tableView.reloadData()
        _ = totalCountUpdate()
        //print(todo)
        
    }
    
    
    //追加③ セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("testaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", todo.count)
        return todo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    //追加④ セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
         let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! taskCell
    
        let rowCounter = todo.count - indexPath.row - 1
        let count = todo[rowCounter].timerCount
        
        
        let h = count/3600
        let m = (count - h*3600)/60
        let s = count - h*3600 - m*60
        
        let h0 =  NSString(format: "%02d", h) as String
        let m0 =  NSString(format: "%02d", m) as String
        let s0 =  NSString(format: "%02d", s) as String
        
        // UNIX時間 "dateUnix" をNSDate型 "date" に変換
        let dateUnix: TimeInterval = TimeInterval(todo[rowCounter].timeStamp)
        let date = NSDate(timeIntervalSince1970: dateUnix)

        // NSDate型を日時文字列に変換するためのNSDateFormatterを生成
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"

        // NSDateFormatterを使ってNSDate型 "date" を日時文字列 "dateStr" に変換
        let dateStr: String = formatter.string(from: date as Date)

        
        cell.timeLabel.text = "\(h0):\(m0):\(s0)"
        cell.taskLabel.text = todo[rowCounter].event
        cell.startLabel.text = dateStr
        //cell.backgroundColor = UIColor(named: "backGroundPink")
        cell.taskLabel.backgroundColor = UIColor(named: "backGroundPink")
        cell.timeLabel.backgroundColor = UIColor(named: "backGroundPink")
        cell.startLabel.backgroundColor = UIColor(named: "backGroundPink")
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
   
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let aaaa = todo[todo.count - indexPath.row - 1].timeStamp
            //let indexPath2: IndexPath = [0, todo.count - indexPath.row - 1]
            let arrIndex = todo.count - indexPath.row - 1
       
            
            var endAlert:UIAlertController
            var endAction = UIAlertAction()
            var cancelAction = UIAlertAction()
            
            if(editingStyle == UITableViewCell.EditingStyle.delete) {
                
                endAlert = UIAlertController(title: "記録は復元できません", message: "消去しますか？", preferredStyle: .alert)
                endAction = UIAlertAction(title: "Yes", style: .default, handler:{
                    (action: UIAlertAction!) -> Void in
                        do{
                                          let realm = try Realm()
                                          let result = realm.objects(Event.self)
                                          let bbb = result.filter("timeStamp = \(aaaa)")
                                          //print(result.filter("timeStamp = \(aaaa)"))
                                          
                                          
                                          try! realm.write {
                                              realm.delete(bbb)
                                          }
                            self.todo.remove(at: arrIndex)
                                          
                            
                                          tableView.performBatchUpdates({
                                              //self.tableView.reloadData()
                                              tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
                                              
                                          }) { (finished) in
                                              _ = self.totalCountUpdate()
                                              self.dateView.reloadData()
                                              print("reload完了しました🙂")
                                          }
                                          
                                          
                                          
                                          
                                      } catch {
                                          
                                      }
                    
                    
                })
                cancelAction = UIAlertAction(title: "No", style: .default, handler:{
                    (action: UIAlertAction!) -> Void in
                    
                    print("cancel")
                })
                
                endAlert.addAction(cancelAction)
                endAlert.addAction(endAction)
                
                
                present(endAlert, animated: true, completion: nil)
            }
        }
    }
    
    func totalCountUpdate() ->  String{
        totalCount = 0
        var pomoCount = 0
        for ev in todo {
            totalCount = totalCount + ev.timerCount
            pomoCount = pomoCount + 1
        }
        if(totalCount > 0) {
            let th = totalCount/3600
            let tm = (totalCount - th*3600)/60
            let ts = totalCount - th*3600 - tm*60
            
            let th0 =  NSString(format: "%02d", th) as String
            let tm0 =  NSString(format: "%02d", tm) as String
            let ts0 =  NSString(format: "%02d", ts) as String
            
            
            totalTime.text = "\(th0):\(tm0):\(ts0)"
        } else {
            totalTime.text = ""
        }
        
   
            
            if (pomoCount > 1) {
                           pomoLabel.text = "\(pomoCount)pomos"
            } else if (pomoCount == 1) {
                           pomoLabel.text = "\(pomoCount)pomo"
            } else {
                pomoLabel.text = ""
            }
        
        
        tableView.reloadData()
        //dateView.reloadData()
        return "OK"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
            let realm = try! Realm()
            let result = realm.objects(Event.self)
            //result = result.filter("date = '\(daPreserve)'")
        
            todo.removeAll()
        //print("てチェック：",daPreserve)
        //print("てチェック：",result)
        for ev in result {
            if ev.date == daPreserve {
                labelDate.text = ev.event
                labelDate.textColor = .black
                //view.addSubview(labelDate)
                todo.append(ev)
                totalCount = totalCount + ev.timerCount
            }
        }
        tableView.reloadData()
        dateView.reloadData()
        _ = totalCountUpdate()
       }
    
    
    // リストの数だけ日付に点マークをつける
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int{
        print(date)
        let tmpCalendar = Calendar(identifier: .gregorian)

        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        let m =  NSString(format: "%02d", month) as String
        let d =  NSString(format: "%02d", day) as String
        
        let dateF = "\(year)/\(m)/\(d)"

        //print(dateF)
        // 対象の日付が設定されているデータを取得する
        do {
            let realm = try Realm()
            let tmpList = realm.objects(Event.self)

            
            //let tmpList = realm.objects(Event.self)
            var hoge = [Event] ()
            hoge.removeAll()
            for ev in tmpList {
                
                print(ev.date,"==",dateF)
                if (String(ev.date) == dateF) {
                    //labelDate.text = ev.event
                    //labelDate.textColor = .black
                    //view.addSubview(labelDate)
                    print("fffffffffffffffffffffffffffffffffffffffffffffffffffffffff")
                    hoge.append(ev)
                    //totalCount = totalCount + ev.timerCount
                }
            }
            print("hoge:",hoge)
            
            return hoge.count
        } catch {
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        let tmpCalendar = Calendar(identifier: .gregorian)

        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        let m =  NSString(format: "%02d", month) as String
        let d =  NSString(format: "%02d", day) as String
        
        let dateF = "\(year)/\(m)/\(d)"
        
        var pomoTime = 0

        //print(dateF)
        // 対象の日付が設定されているデータを取得する
        do {
            let realm = try Realm()
            let tmpList = realm.objects(Event.self)

            
            //let tmpList = realm.objects(Event.self)
            var hoge = [Event] ()
            hoge.removeAll()
            for ev in tmpList {
                
                print(ev.date,"==",dateF)
                if (String(ev.date) == dateF) {
                    pomoTime = pomoTime + ev.timerCount
                    hoge.append(ev)
                    //totalCount = totalCount + ev.timerCount
                }
            }
            print("hoge:",hoge)
            
            if pomoTime >= 10800 {
                return [UIColor.red]
            } else if pomoTime >= 5400 {
                return [UIColor.orange]
            }
            return nil
        } catch {
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let tmpCalendar = Calendar(identifier: .gregorian)

        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        let m =  NSString(format: "%02d", month) as String
        let d =  NSString(format: "%02d", day) as String
        
        let dateF = "\(year)/\(m)/\(d)"
        
        var pomoTime = 0

        do {
            let realm = try Realm()
            let tmpList = realm.objects(Event.self)

            var hoge = [Event] ()
            hoge.removeAll()
            for ev in tmpList {
                
                print(ev.date,"==",dateF)
                if (String(ev.date) == dateF) {
                    
                    print("fffffffffffffffffffffffffffffffffffffffffffffffffffffffff")
                    pomoTime = pomoTime + ev.timerCount
                    hoge.append(ev)
                    //totalCount = totalCount + ev.timerCount
                }
            }
            print("hoge:",hoge)
            
            if pomoTime >= 10800 {
                return [UIColor(named: "buttonPink")!]
            } else if pomoTime >= 5400 {
                return [UIColor(named: "buttonOrange")!]
            } else {
                return [UIColor(named: "buttonGreen")!]
            }
            
        } catch {
        }
        return nil
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
           //setLabel()
       }
    func setLabel(){
        
        switch UIDevice.current.model {
        case "iPnone" :
        print("これはiPhone")
            break
        case "iPad" :
            print("これはiPad")
            let screenWidth:CGFloat = UIScreen.main.bounds.size.height
            let screenHeight:CGFloat = UIScreen.main.bounds.size.width * 0.6
            // ラベルのサイズを設定
            
            dateView.setScope(.month, animated: false)

            dateView.frame = CGRect(x:0, y:30,
                                        width:screenWidth, height:screenHeight)

            
            break
        default:
            break
        }
    
        
       }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // ここに回転時の処理
        
        switch UIDevice.current.model {
        case "iPnone" :
        print("これはiPhone")
            break
        case "iPad" :
            print("これはiPad")
            //dateView = FSCalendar(frame: CGRect(x: 0, y: 30, width: w, height: 420))
            let screenWidth:CGFloat = UIScreen.main.bounds.size.width
            let screenHeight:CGFloat = UIScreen.main.bounds.size.height * 0.6
            // ラベルのサイズを設定
            
            dateView.frame = CGRect(x:0, y:30,
                                        width:screenWidth, height:screenHeight)
            let isLandscape = UIDevice.current.orientation.isLandscape
            if isLandscape {
                 dateView.setScope(.month, animated: true)
            }
            
            break
        default:
            break
        }
    }
}

