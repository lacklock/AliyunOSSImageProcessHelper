//
//  OSSImageProcess.swift
//  AliyunOSSImageProcessHelper
//
//  Created by 卓同学 on 2017/10/24.
//  Copyright © 2017年 XiaoYu. All rights reserved.
//

import UIKit

open class OSSImageProcess {

    var url: String
    public init(url: String){
        self.url = url
    }
    
    var actions = [ImageProcessAction]()
    
    /// 缩略的模式
    ///
    /// - lift: 等比缩放，限制在设定在指定w与h的矩形内的最大图片
    /// - mfit: 等比缩放，延伸出指定w与h的矩形框外的最小图片
    /// - fill: 固定宽高，将延伸出指定w与h的矩形框外的最小图片进行居中裁剪
    /// - pad: 固定宽高，缩略填充
    /// - fixed: 固定宽高，强制缩略
    public enum Mode: String {
        case lift
        case mfit
        case fill
        case pad
        case fixed
    }
    
    var resizeAction: ResizeAction?
    
    /// 将图片按照要求生成缩略图，或者进行特定的缩放,图片处理支持的格式：jpg、png、bmp、gif、webp、tiff
    ///
    /// - Parameters:
    ///   - width: 宽度,1-4096
    ///   - height: 高度,1-4096
    ///   - mode: 缩略的模式
    ///   - limit: 当目标缩略图大于原图时是否处理。值是 1 表示不处理；值是 0 表示处理。默认是 1
    ///   - color: 填充的颜色(默认是白色),采用16进制颜色码表示，如00FF00（绿色）
    public func resize(width: Int? = nil, height: Int? = nil, mode: Mode? = nil, limit: String? = nil, color: String? = nil) -> OSSImageProcess {
        if resizeAction == nil {
            resizeAction = ResizeAction()
            actions.append(resizeAction!)
        }
        resizeAction?.width = width
        resizeAction?.height = height
        resizeAction?.mode = mode
        resizeAction?.limit = limit
        resizeAction?.color = color
        return self
    }
    
    /// 倍数百分比。 小于100，即是缩小，大于100即是放大。取值范围1-1000
    public func rezie(scalePercentage: Int) -> OSSImageProcess {
        if resizeAction == nil {
            resizeAction = ResizeAction()
            actions.append(resizeAction!)
        }
        resizeAction?.scalePercentage = scalePercentage
        return self
    }
    
    var blurAction: BlurAction?
    /// 对图片进行模糊操作
    ///
    /// - Parameters:
    ///   - radius: 模糊半径,[1,50]
    ///   - s: 正态分布的标准差,[1,50]
    public func blur(radius: Int, s: Int) -> OSSImageProcess {
        if blurAction == nil {
            blurAction = BlurAction(raidus: radius, s: s)
            actions.append(blurAction!)
        }else {
            blurAction?.raidus = radius
            blurAction?.s = s
        }
        return self
    }
    
    var formatAction: FormatAction?
    public enum Format: String {
        case jpg,png,webp,bmp,gif
    }
    public func format(_ format: Format) -> OSSImageProcess {
        if formatAction == nil {
            formatAction = FormatAction(format: format)
            actions.append(formatAction!)
        }
        formatAction?.format = format
        return self
    }
    
    public func render() -> String {
        guard actions.count > 0 else {
            assertionFailure("no image action")
            return ""
        }
        var parameter = "\(url)?x-oss-process=image"
        actions.forEach {
            if let actionString = $0.render() {
                parameter.append("/\(actionString)")
            }
        }
        return parameter
    }
}

protocol ImageProcessAction {
    var action: String { get }
    func render() -> String?
}

class ResizeAction: ImageProcessAction {
    //阿里云文档：https://help.aliyun.com/document_detail/44688.html?spm=5176.doc44701.6.944.pC1kYZ
    
    var action = "resize"
    
    var mode: OSSImageProcess.Mode?
    var width: Int?
    var height: Int?
    var limit: String?
    
    /// 倍数百分比。 小于100，即是缩小，大于100即是放大。取值范围1-1000
    var scalePercentage: Int?
    
    /// 当缩放模式选择为pad（缩略填充）时，可以选择填充的颜色(默认是白色)参数的填写方式：采用16进制颜色码表示，如00FF00（绿色）
    var color: String?
    
    func render() -> String? {
        var parameters = [String]()
        if let mode = mode {
            parameters.append("m_\(mode.rawValue)")
        }
        if let width = width {
            parameters.append("w_\(width)")
        }
        if let height = height {
            parameters.append("h_\(height)")
        }
        if let limit = limit {
            parameters.append("limit_\(limit)")
        }
        if let color = color {
            parameters.append("color_\(color)")
        }
        if let scalePercentage = scalePercentage {
            parameters.append("p\(scalePercentage)")
        }
        if parameters.count > 0 {
            let parametersString = parameters.joined(separator: ",")
            return "\(action),\(parametersString)"
        }else {
            return nil
        }
    }
}

