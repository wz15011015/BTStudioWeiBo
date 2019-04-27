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
                print("创建表 成功 !")
            } else {
                print("创建表 失败 !")
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
        // rollback: 布尔的指针 UnsafeMutablePointer<ObjCBool> --> *stop
        queue.inTransaction { (database, rollback) in
            // 遍历数组,逐条插入微博数据
            for dict in array {
                // 获取微博ID
                guard let statusId = dict["idstr"] as? String,
                    // 将字典序列化成 二进制 数据
                    let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
                        continue
                }
                
                // 执行SQL
                let isSuccess = database.executeUpdate(sql, withArgumentsIn: [statusId, userId, jsonData])
                if isSuccess {
//                    print("插入微博数据 成功 !")
                } else {
                    print("插入微博数据 失败 !")
                    
                    // 需要回滚  *rollback = YES;
                    // Swift 1.x & 2.x 写法:  rollback.memory = true
                    // Swift现在的写法:
                    rollback.pointee = true
                    break
                }
            }
        }
    }
    
    /// 执行一个SQL,返回字典的数组
    ///
    /// - Parameter sql: SQL语句
    /// - Returns: 字典的数组
    func executeRecordSet(sql: String) -> [[String: Any]] {
        
        var array: [[String: Any]] = []
        
        // 执行SQL - 查询数据,不会修改数据,所以不需要开启事务
        // 事务的目的是为了保证数据的有效性,一旦失败,回滚到初始状态
        queue.inDatabase { (database) in
            guard let results = database.executeQuery(sql, withArgumentsIn: []) else {
                return
            }
            // 遍历结果集合 - 逐行
            while results.next() {
                // 1. 列数
                let columnCount = results.columnCount
                
                // 2. 遍历所有列
                for column in 0..<columnCount {
                    // 列名(Key) 列值(Value)
                    guard let name = results.columnName(for: column),
                        let value = results.object(forColumnIndex: column) else {
                            continue
                    }
                    // 追加数据
//                    print("key: \(name), value: \(value)")
                    array.append([name: value])
                }
            }
        }
        
        return array
    }
    
    /// 从数据库加载微博数据
    ///
    /// - Parameters:
    ///   - userId: 当前登录用户的ID
    ///   - since_id: 返回ID比since_id大的微博
    ///   - max_id: 返回ID比max_id小的微博
    /// - Returns: 微博字典数组
    func loadStatus(userId: String, since_id: Int64 = 0, max_id: Int64 = 0) -> [[String: Any]] {
        // 1. 准备SQL
        var sql = "SELECT statusId, userId, status FROM T_Status \n"
        sql += "WHERE userId = \(userId) \n"
        
        if since_id > 0 {
            sql += "AND statusId > \(since_id) \n"
        } else if max_id > 0 {
            sql += "AND statusId < \(max_id) \n"
        }
        
        sql += "ORDER BY statusId DESC LIMIT 20;"
        
        // 2. 执行SQL
        let array = executeRecordSet(sql: sql)
        
        // 3. 遍历数组,将数组中的 status 反序列化
        var status: [[String: Any]] = []
        for dict in array {
            guard let jsonData = dict["status"] as? Data,
                let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                continue
            }
            // 追加到数组
            status.append(json)
        }
        
        return status
    }
}
