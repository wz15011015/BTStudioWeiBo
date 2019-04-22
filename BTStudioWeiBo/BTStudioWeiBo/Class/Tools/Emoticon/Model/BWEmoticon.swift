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
    
    /// 表情字符串(简体中文) -- 用于发送给服务器(以节省流量)
    var chs: String?
    
    /// 表情字符串(繁体中文)
    var cht: String?
    
    /// 表情图片的名称 -- 用于本地图文混排
    var png: String?
    
    /// 表情gif图片的名称
    var gif: String?
    
    /// emoji的十六进制编码
    var code: String?
    
    /// 表情图片所在的目录
    var directory: String?
    
    /// 图片表情对应的图片 (计算型属性)
    var image: UIImage? {
        // 判断表情类型
        // 1. emoji
        if type {
            return nil
        }
        // 2. 图片表情
        guard let directory = directory,
            let png = png,
            let path = Bundle.main.path(forResource: "BWEmoticon", ofType: "bundle"),
            let bundle = Bundle(path: path) else {
                return nil
        }
        
        let image = UIImage(named: "\(directory)/\(png)", in: bundle, compatibleWith: nil)
        
        return image
    }
    
    override var description: String {
        return yy_modelDescription()
    }
}