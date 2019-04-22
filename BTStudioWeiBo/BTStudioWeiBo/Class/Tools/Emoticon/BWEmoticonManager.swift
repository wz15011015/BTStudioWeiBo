//
//  BWEmoticonManager.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/22.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/// 表情管理器
class BWEmoticonManager {
    
    // 为了便于表情的复用,建立一个单例,只加载一次表情数据
    /// 表情管理器单例
    static let shared = BWEmoticonManager()
    
    /// 表情包数组
    lazy var packages: [BWEmoticonPackage] = []
    
    
    /// 构造函数
    ///
    /// 如果在init()之前增加 private 修饰符,可以要求调用者必须通过 shared 访问对象
    /// 在 OC 中需要重写 allocWithZone 方法
    private init() {
        loadPackages()
    }
}


// MARK: - 表情符号处理
extension BWEmoticonManager {
    
    /// 根据表情字符串(例如: [爱你])在所有的表情符号中查找对应的表情模型
    ///
    /// - Parameter chs: 表情字符串
    /// - Returns: 如果找到,返回表情模型,否则,返回nil
    func findEmoticon(chsString chs: String) -> BWEmoticon? {
        // 1. 遍历表情包
        for package in packages {
            // 2. 在表情数组中过滤 chs
            // 方法一:
//            let result = package.emoticons.filter { (emoticon) -> Bool in
//                return emoticon.chs == chs
//            }
            
            /**
             如果闭包中只有一句代码,并且是返回语言,则:
             - 闭包的定义格式可以省略
             - 参数省略之后,使用 $0, $1, $2, ... 依次代替原有参数
             - return 也可以省略
             */
            // 方法二:
//            let result = package.emoticons.filter {
//                return $0.chs == chs
//            }
            
            // 方法三:
            let result = package.emoticons.filter { $0.chs == chs }
            
            if result.count == 1 {
                return result.first
            }
        }
        
        return nil
    }
}


// MARK: - 表情包数据处理
private extension BWEmoticonManager {
    // 读取 emoticons.plist
    // 只要按照 Bundle 默认的目录结构设定,就可以直接读取 Resources 目录下的文件
    func loadPackages() {
        guard let path = Bundle.main.path(forResource: "BWEmoticon", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let plistPath = bundle.path(forResource: "emoticons", ofType: "plist"),
            let array = NSArray(contentsOfFile: plistPath) as? [[String: String]],
            let models = NSArray.yy_modelArray(with: BWEmoticonPackage.self, json: array) as? [BWEmoticonPackage] else {
            return
        }
        
        packages += models
    }
}
