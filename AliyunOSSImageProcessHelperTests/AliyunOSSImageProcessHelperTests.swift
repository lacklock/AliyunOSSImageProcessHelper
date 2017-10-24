//
//  AliyunOSSImageProcessHelperTests.swift
//  AliyunOSSImageProcessHelperTests
//
//  Created by 卓同学 on 2017/10/24.
//  Copyright © 2017年 XiaoYu. All rights reserved.
//

import XCTest
@testable import AliyunOSSImageProcessHelper

class AliyunOSSImageProcessHelperTests: XCTestCase {
    
    func testRender() {
        let url = "http://image-demo.oss-cn-hangzhou.aliyuncs.com/example.jpg"
        let rendered = url.ossImageProcess()
            .resize(width: 200, height: 100)
            .blur(radius: 2, s: 1)
            .format(.png).render()
        XCTAssertEqual("http://image-demo.oss-cn-hangzhou.aliyuncs.com/example.jpg?x-oss-process=image/resize,w_200,h_100/blur,r_2,s_1/format,png", rendered)
    }
    
}
