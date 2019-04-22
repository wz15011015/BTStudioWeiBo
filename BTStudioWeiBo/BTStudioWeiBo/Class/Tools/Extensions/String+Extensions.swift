//
//  String+Extensions.swift
//  002-正则表达式
//
//  Created by apple on 16/7/10.
//  Copyright © 2016年 itcast. All rights reserved.
//

import Foundation

extension String {
    
    /// 从当前字符串中，提取链接和文本
    /// Swift 提供了`元组`，同时返回多个值
    /// 如果是 OC，可以返回字典／自定义对象／指针的指针
    func cz_href() -> (link: String, text: String)? {
        
        /**
         
         索引:
         - 0: 和匹配方案完全一致的字符串
         - 1: 第一个()中的内容
         - 2: 第二个()中的内容
         ... 索引是从左向右顺序递增
         
         
         对应模糊匹配:
         - 如果关心内容,就使用(.*?),然后通过索引可以获取结果
         - 如果不关心内容,就使用.*?,可以匹配任意内容
         
         
         查找结果:
         - .numberOfRanges: 查找到的范围的数量
         - .range(at: 4) : 第4个范围
         */
        
        // 0. 匹配方案
        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"
        
        // 1. 创建正则表达式，并且匹配第一项
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []),
            let result = regx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count))
            // FIXME: 修改了代码,需要审查
            else {
                return nil
        }
        
        // 2. 获取结果
        let link = (self as NSString).substring(with: result.range(at: 1))
        let text = (self as NSString).substring(with: result.range(at: 2))
        
        return (link, text)
    }
}
