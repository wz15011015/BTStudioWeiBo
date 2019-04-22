//
//  BWEmoticon.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/22.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/// 表情模型
@objcMembers class BWEmoticon: NSObject {
    
    /// 表情类型 -- false: 图片表情  true: emoji
    var type = false
    
    /// 表情字符串 -- 用于发送给服务器(以节省流量)
    var chs: String?
    
    /// 表情图片名称 -- 用于本地图文混排
    var png: String?
    
    /// emoji的十六进制编码
    var code: String?
    
    override var description: String {
        return yy_modelDescription()
    }
}
