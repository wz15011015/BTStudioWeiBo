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
    @objc var thumbnail_pic: String?
    
    override var description: String {
        return yy_modelDescription()
    }
}
