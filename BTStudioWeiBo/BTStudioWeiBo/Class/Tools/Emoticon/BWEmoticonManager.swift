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
