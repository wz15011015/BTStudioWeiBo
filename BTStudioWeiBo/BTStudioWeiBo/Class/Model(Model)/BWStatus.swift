//
//  BWStatus.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/9.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit
import YYModel

/// 微博数据模型
class BWStatus: NSObject {
    
    /// 微博ID
    ///
    /// Int类型,在64位机器里是64位,32位机器里就是32位
    @objc var id: Int64 = 0
    
    /// 微博信息内容
    @objc var text: String?
    
    /// 重写计算型属性 description
    override var description: String {
        return yy_modelDescription()
    }
    
    
//    override init() {
//        super.init()
//    }
//
//    // 重载
//    init(dictionary: [String: Any]) {
//        super.init()
//
//        setValuesForKeys(dictionary)
//    }
    
//    override func setValue(_ value: Any?, forUndefinedKey key: String) {
//
//    }
}
