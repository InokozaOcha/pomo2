//
//  TimerSetting.swift
//  pomo2
//
//  Created by Tanaka Kenta on 2020/01/16.
//  Copyright © 2020 PrestSQuare. All rights reserved.
//

import Foundation
import RealmSwift

class TimerSetting: Object {
    //Running用
    @objc dynamic var Rh: Int = 100
    @objc dynamic var Rm: Int = 100
    @objc dynamic var Rs: Int = 100
    //Break用
    @objc dynamic var Bh: Int = 100
    @objc dynamic var Bm: Int = 100
    @objc dynamic var Bs: Int = 100
    //繰り返し回数用
    @objc dynamic var count: Int = -1
    
}
