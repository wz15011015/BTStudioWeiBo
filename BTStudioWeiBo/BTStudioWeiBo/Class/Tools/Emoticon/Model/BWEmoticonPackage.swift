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
    
    /// 分组按钮的背景图片名称
    var bgImageName: String?
    
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
    
    /// 表情的页数(每页20个表情)
    var numberOfPages: Int {
        return (emoticons.count - 1) / 20 + 1
    }
    
    
    /// 从表情包模型中加载每页的表情模型数据
    ///
    /// - Parameter page: 页码
    /// - Returns: 表情模型数组
    func emoticons(at page: Int) -> [BWEmoticon] {
//        let range = 0..<20
//        let pageEmoticons = range.relative(to: emoticons)
//        return emoticons[0...19]
        
        
        // 每页的数量
        let count = 20
        let location = page * 20
        var length = count
        
        // 数组越界判断
        if location + length > emoticons.count {
            length = emoticons.count - location
        }
        
        let range = NSMakeRange(location, length)
        let pageEmoticons = (emoticons as NSArray).subarray(with: range)
        return pageEmoticons as! [BWEmoticon]
    }
    
    override var description: String {
        return yy_modelDescription()
    }
}
