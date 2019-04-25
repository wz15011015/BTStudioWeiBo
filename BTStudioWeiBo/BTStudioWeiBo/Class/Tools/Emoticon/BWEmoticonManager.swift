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
    
    /// 表情素材Bundle
    lazy var bundle: Bundle = {
        let path = Bundle.main.path(forResource: "BWEmoticon", ofType: "bundle")
        let bundle = Bundle(path: path!)
        return bundle!
    }()
    
    
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
    
    /// 将给定的字符串转换成属性字符串
    ///
    /// - Parameter string: 字符串
    /// - Returns: 属性字符串
    func emoticonString(string: String, font: UIFont) -> NSAttributedString {
        let attributedStr = NSMutableAttributedString(string: string)
        
        // 1. 使用正则表达式过滤所有表情文字
        // [^ \\n\\f\\r\\t\\v\\[\\]] 匹配任何非空白字符和 [ 、]  其中空白符即空格、换行符、换页符、回车符、水平制表符、垂直制表符
        let pattern = "\\[[^ \\f\\n\\r\\t\\v\\[\\]]*?\\]"
        guard let regEx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return attributedStr
        }
        
        // 2. 匹配所有项
        let results = regEx.matches(in: string, options: [], range: NSMakeRange(0, string.count))
        
        /**
         注意点: 应该倒序遍历
         
         我[爱你]的心[笑哈哈]!
         
         查找到的范围:
         - range1: {1, 4}
         - range2: {6, 5}
         
         1. 正序
         我◻︎的心[笑哈哈]!
         - 正序替换时,当替换了"[爱你]"之后,后面"[笑哈哈]"的范围就发生了改变,其范围会失效
         
         2. 倒序 (一次循环可以把所有的图片全部替换)
         我[爱你]的心◻︎!
         - 倒序替换时,当替换了"[笑哈哈]"之后,前面"[爱你]"的范围不会改变
         */
        
        // 3. 遍历所有匹配结果
        for result in results.reversed() {
            // a. 获取 表情字符 的范围
            let range = result.range(at: 0)
            
            // b. 截取 表情字符
            let chsStr = (string as NSString).substring(with: range)
//            print("表情字符: \(chsStr)")
            
            // c. 使用 表情字符 查找对应的表情模型
            if let emoticon = findEmoticon(chsString: chsStr) {
//                print("表情模型: \(emoticon)")
                // d. 使用表情模型中的 图片属性文本 替换原有文本中的表情字符
                attributedStr.replaceCharacters(in: range, with: emoticon.imageText(font: font))
            }
        }
        
        // 统一设置字符串的属性
        // 统一字体
        attributedStr.addAttributes([NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.darkGray], range: NSMakeRange(0, attributedStr.string.count))
        
        return attributedStr
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
