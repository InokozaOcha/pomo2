//
//  SettingTask.swift
//  pomo2
//
//  Created by Tanaka Kenta on 2020/01/20.
//  Copyright © 2020 PrestSQuare. All rights reserved.
//

import UIKit

class SettingTask: UIViewController, UITextFieldDelegate {
    //var textField:Array<Any>!
    
    var i = 0
   // var textField = UITextField()
    override func viewDidLoad() {
        //view.backgroundColor = UIColor.init(red: 230/255, green: 255/255, blue: 230/255, alpha: 90/100)
        super.viewDidLoad()
        
        DoneButton.layer.cornerRadius = 5
        
        let settings = UserDefaults.standard
        
        let loop = settings.integer(forKey: "repeat")
        for i in 0 ..< loop {
            let taskNo = "task\(i+1)"
            let textField = UITextField()
            textField.frame = CGRect(x: 10, y: 100+i*40, width: Int(UIScreen.main.bounds.size.width-20), height: 38)
            textField.text = settings.string(forKey: taskNo)
            // プレースホルダを設定
            textField.placeholder = "task\(i+1)の内容入力してください。"
            // キーボードタイプを指定
            textField.keyboardType = .default
            // 枠線のスタイルを設定
            textField.borderStyle = .roundedRect
            // 改行ボタンの種類を設定
            textField.returnKeyType = .done
            // テキストを全消去するボタンを表示
            textField.clearButtonMode = .always
            // UITextFieldを追加
            self.view.addSubview(textField)
            // デリゲートを指定
            textField.delegate = self
            textField.tag = i
            // Do any additional setup after loading the view.
        }
        //view.backgroundColor = UIColor.init(red: 211/255, green: 244/255, blue: 213/255, alpha: 100/100)
    }
    
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    let settings = UserDefaults.standard
    switch textField.tag {
        case 0:
            settings.setValue(textField.text,forKey:"task1")
            settings.synchronize()
        case 1:
            settings.setValue(textField.text,forKey:"task2")
            settings.synchronize()
        case 2:
            settings.setValue(textField.text,forKey:"task3")
            settings.synchronize()
        case 3:
            settings.setValue(textField.text,forKey:"task4")
            settings.synchronize()
        case 4:
            settings.setValue(textField.text,forKey:"task5")
            settings.synchronize()
        case 5:
            settings.setValue(textField.text,forKey:"task6")
            settings.synchronize()
        case 6:
            settings.setValue(textField.text,forKey:"task7")
            settings.synchronize()
        case 7:
            settings.setValue(textField.text,forKey:"task8")
            settings.synchronize()
        case 8:
            settings.setValue(textField.text,forKey:"task9")
            settings.synchronize()
        case 9:
            settings.setValue(textField.text,forKey:"task10")
            settings.synchronize()
        default:
            print("これが返ることはないねんけどな")
    }
    
    return true
      
  }
  
       

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

  
    
    
    @IBAction func backMain(_ sender: Any) {
        dismiss(animated: true).self
        print("input")
    }
    
    func textField(_ textField: UITextField) -> Bool {
        if textField.tag == 2 {
            print("変更中")
        }
      
      return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    
    @IBOutlet weak var DoneButton: UIButton!
    
    
}
