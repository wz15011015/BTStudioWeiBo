//
//  BWUserAccount.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/10.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/// 用户账户信息沙盒文件的名称
private let accountFile: NSString = "BWUserAccount.json"

/// 用户账户模型  @objcMembers
class BWUserAccount: NSObject {
    
    /// 访问令牌
    @objc var access_token: String?
    
    /// 用户ID
    @objc var uid: String?
    
    /// 过期时间(单位:秒数)
    ///
    /// 使用者: 3天时间,会从第一次登录递减
    @objc var expires_in: TimeInterval = 0 {
        didSet {
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    /// 过期日期
    @objc var expiresDate: Date?
    
    /// 用户昵称
    @objc var screen_name: String?
    
    /// 用户头像地址（大图），180×180像素
    @objc var avatar_large: String?
    
    
    override var description: String {
        return yy_modelDescription()
    }
    
    
    override init() {
        super.init()
        
        // 加载用户账户信息
        guard let filePath = accountFile.cz_appendDocumentDir(),
            let jsonString = try? String.init(contentsOfFile: filePath),
            let data = jsonString.data(using: .utf8),
            let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return
        }
        
        // 使用字典设置属性值
        // FIXME: 调试代码
        setValuesForKeys(dict)
        
        // FIXME: 测试代码
//        expiresDate = Date(timeIntervalSinceNow: -3600 * 1)
        // 判断 access_token 是否过期
        let result = expiresDate?.compare(Date())
        if result != .orderedDescending {
            print("access_token 已过期!")
            
            // 清空用户账户信息
            access_token = nil
            uid = nil
            
            // 删除账户信息文件
            try? FileManager.default.removeItem(atPath: filePath)
        }
    }
    
    /**
     * 1. 偏好设置
     * 2. 沙盒 - 归档/plist/json
     * 3. 数据库 (FMDB/CoreData)
     * 4. 钥匙串访问 (自动加密 / 需要使用框架SSKeyChain)
     */
    
    /// 保存用户账户信息到沙盒
    func saveAccount() {
        // 1. 模型转字典
        var dict = self.yy_modelToJSONObject() as? [String: Any] ?? [:]
        // 删除expires_in值
        dict.removeValue(forKey: "expires_in")
        
        // 2. 字典序列化 data
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
            let fileName = accountFile.cz_appendDocumentDir() else {
            return
        }
        print("fileName: \(fileName)")
        // 3. 写入磁盘
//        try? data.write(to: URL(fileURLWithPath: fileName, isDirectory: true))
        do {
            try data.write(to: URL(fileURLWithPath: fileName, isDirectory: true))
        } catch {
            print("用户账户写入磁盘出错,error: \(error)")
        }
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "expiresDate" {
            // 1. 因为使用DateFormatter转换后的日期为零时区日期,所以需要处理时差问题
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let gmtDate = formatter.date(from: value as? String ?? "")
            
            // 2. 处理时差问题
            // 当前时区
            let timezone = TimeZone.current
            // 当前时区与零时区的秒数差
            let timeInterval = Double(timezone.secondsFromGMT(for: gmtDate ?? Date()))
            
            // 处理时差后的日期
            expiresDate = gmtDate?.addingTimeInterval(timeInterval)
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("BWUserAccount Undefined Key: \(key)")
    }
}
