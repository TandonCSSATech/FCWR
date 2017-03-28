//
//  Jiabin.swift
//  FCWR
//
//  Created by zhuchenglong on 17/2/15.
//  Copyright © 2017年 goodcoder.zcl. All rights reserved.
//

import Foundation
import RealmSwift

class Jiabin: Object {
    
    dynamic var xingbie:String = ""
    var renshu = List<Haoma>()
}
