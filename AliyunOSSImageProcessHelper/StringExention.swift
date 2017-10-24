//
//  StringExention.swift
//  AliyunOSSImageProcessHelper
//
//  Created by 卓同学 on 2017/10/24.
//  Copyright © 2017年 XiaoYu. All rights reserved.
//

import Foundation

public extension String {
    
    public func ossImageProcess() -> OSSImageProcess {
        return OSSImageProcess(url: self)
    }
    
}
