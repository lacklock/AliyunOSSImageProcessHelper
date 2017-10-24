//
//  Actions.swift
//  AliyunOSSImageProcessHelper
//
//  Created by 卓同学 on 2017/10/24.
//  Copyright © 2017年 XiaoYu. All rights reserved.
//

import Foundation

class BlurAction: ImageProcessAction {
    var action = "blur"
    
    var raidus: Int
    var s: Int
    
    public init(raidus: Int, s: Int) {
        self.raidus = raidus
        self.s = s
    }
    
    func render() -> String? {
        return "\(action),r_\(raidus),s_\(s)"
    }
}

class FormatAction: ImageProcessAction {
    var action = "format"
    
    var format: OSSImageProcess.Format
    
    init(format: OSSImageProcess.Format) {
        self.format = format
    }
    
    func render() -> String? {
        return "\(action),\(format.rawValue)"
    }
}
