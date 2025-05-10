//
//  Event.swift
//  pomo2
//
//  Created by Tanaka Kenta on 2020/01/16.
//  Copyright © 2020 PrestSQuare. All rights reserved.
//

import Foundation
import RealmSwift

class Event: Object {

    @objc dynamic var date: String = ""
    @objc dynamic var event: String = ""
    @objc dynamic var timerCount: Int = 0
    @objc dynamic var timeStamp: Int = 0
    
}
