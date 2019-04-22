//
//  BWEmoticonPackage.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/22.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/// 表情包模型
@objcMembers class BWEmoticonPackage: NSObject {
    
    /// 表情包的分组名
    var groupName: String?
    
    /// 表情包目录, 从目录下加载info.plist,可以创建表情模型数组
    var directory: String? {
        didSet {
            // 当设置目录时,从目录下加载 info.plist
            guard let directory = directory,
                let path = Bundle.main.path(forResource: "BWEmoticon", ofType: "bundle"),
                let bundle = Bundle(path: path),
                let plistPath = bundle.path(forResource: "info", ofType: "plist", inDirectory: directory),
                let array = NSArray(contentsOfFile: plistPath) as? [[String: String]],
                let models = NSArray.yy_modelArray(with: BWEmoticon.self, json: array) as? [BWEmoticon] else {
                return
            }
            // 遍历models数组,设置每一个表情模型的图片目录
            for emoticon in models {
                emoticon.directory = directory
            }
            
            emoticons += models
        }
    }
    
    /// 表情模型数组
    ///
    /// 使用懒加载可以避免后续的解包
    lazy var emoticons: [BWEmoticon] = []
    
    override var description: String {
        return yy_modelDescription()
    }
}
