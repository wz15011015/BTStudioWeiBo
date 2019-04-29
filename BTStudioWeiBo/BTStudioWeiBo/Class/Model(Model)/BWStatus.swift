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
    
    /// 创建时间
    @objc var created_at: String? {
        didSet {
            createDate = Date.cz_sinaDate(string: created_at ?? "")
        }
    }
    
    /// 创建时间日期(Date)
    @objc var createDate: Date?
    
    /// 微博来源 - 发布微博使用的客户端
    @objc var source: String? {
        didSet {
            // 在didSet中,给source设置值,不会再调用didSet
            source = "来自 " + (source?.cz_href()?.text ?? "")
        }
    }
    
    /// 转发数
    @objc var reposts_count: Int = 0
    
    /// 评论数
    @objc var comments_count: Int = 0
    
    /// 点赞数
    @objc var attitudes_count: Int = 0
    
    /// 微博的用户
    @objc var user: BWUser?
    
    /// 微博配图地址数组 (容器类属性)
    /**
     * YYModel在字典转模型时,如果发现一个数组属性,则尝试调用类方法
     * modelContainerPropertyGenericClass,如果实现了该类方法
     * YYModel会尝试使用类来实例化数组中的对象
     *
     * 所有的第三方框架基本都是如此!
     */
    @objc var pic_urls: [BWStatusPicture]?
    
    /// 被转发的原创微博
    @objc var retweeted_status: BWStatus?
    
    /// 重写计算型属性 description
    override var description: String {
        return yy_modelDescription()
    }
    
    /// 容器类属性 (类方法)
    ///
    /// - Returns: 容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
    /**
     * 作用: 告诉第三方框架,如果遇到数组类型的属性,数组中存放的对象是什么类
     *
     * NSArray中保存的对象的类型通常是 id 类型
     * OC中的泛型是 Swift 推出后,苹果为了兼容而给OC增加的
     * 从运行时角度看,仍然不知道数组中应该存放什么类型的对象
     */
    @objc class func modelContainerPropertyGenericClass() -> [String: AnyClass] {
        return ["pic_urls": BWStatusPicture.self]
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
