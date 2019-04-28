//
//  BWStatusPicture.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/15.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/// 微博配图模型
class BWStatusPicture: NSObject {
    
    /// 缩略图地址
    @objc var thumbnail_pic: String? {
        didSet {
            // 设置大尺寸图片
            large_pic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/large/")
            
            // 更改缩略图地址
            thumbnail_pic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/wap360/")
        }
    }
    
    /// 大尺寸图片地址
    @objc var large_pic: String?
    
    override var description: String {
        return yy_modelDescription()
    }
}
