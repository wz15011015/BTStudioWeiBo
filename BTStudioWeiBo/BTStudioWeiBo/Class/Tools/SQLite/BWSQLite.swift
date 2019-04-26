//
//  BWSQLite.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/26.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import Foundation
import FMDB

/**
 * 1. 数据库本质上是保存在沙盒中的一个文件,首先需要创建并且打开数据库;
 *    FMDB - 队列
 *
 * 2. 创建数据表
 *
 * 3. 增删改查
 *
 */

/// SQLite管理器
class BWSQLiteManager {
    
    /// 数据库单例 - 全局数据库的访问点
    static let shared = BWSQLiteManager()
    
    /// 数据库队列
    let queue: FMDatabaseQueue
    
    
    /// 构造函数 - private保证使用者只能通过shared获取单例对象,不能使用init构造函数创建实例对象
    private init() {
        // 数据库的全路径
        let databaseName = "BWStatus.db"
        var databasePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        databasePath = (databasePath as NSString).appendingPathComponent(databaseName)
        print("数据库路径: \(databasePath)")
        
        // 创建数据库队列
        queue = FMDatabaseQueue(path: databasePath)!
        
        createTable()
    }
}


// MARK: - 创建数据表以及其他私有方法
private extension BWSQLiteManager {
    
    /// 创建数据表
    func createTable() {
        // 1. 准备SQL
        guard let path = Bundle.main.path(forResource: "status", ofType: "sql"),
            let sql = try? String(contentsOfFile: path) else {
            return
        }
        print("SQL语句: \(sql)")
        
        // 2. 执行SQL - FMDB内部队列是 串行队列, 同步执行
        // 可以保证同一时间,只有一个任务操作数据库,从而保证数据库的读写安全!
        queue.inDatabase { (database) in
            // 只有在创建表的时候,使用执行多条语句,可以一次创建多个数据表
            // 在执行 增/删/改 的时候,一定不要使用 statements 方法,否则有可能会被注入!
            
            if database.executeStatements(sql) == true {
                print("创建表 成功")
            } else {
                print("创建表 失败")
            }
        }
        print("执行顺序...")
    }
}


// MARK: - 微博数据操作
extension BWSQLiteManager {
    
    /// 新增或修改微博数据
    ///
    /// - Parameters:
    ///   - userId: 当前登录用户的ID
    ///   - array: 从网络加载的微博的'字典数组'
    func updateStatus(userId: String, array: [[String: Any]]) {
        // 1. 准备SQL
        /**
         statusId: 要保存的微博ID
         userId: 当前登录用户的ID
         status: 完整微博字典的 json二进制数据
         
         从网络加载数据结束后,返回的是微博的'字典数组',每一个字典对应一个完整的微博记录
         - 完整的微博记录中包含微博的ID
         - 微博记录中,没有当前登录用户的ID
         */
        let sql = "INSERT OR REPLACE INTO T_Status (statusId, userId, status) VALUES (?, ?, ?);"
        
        // 2. 执行SQL
        queue.inDatabase { (database) in
            
        }
    }
}
