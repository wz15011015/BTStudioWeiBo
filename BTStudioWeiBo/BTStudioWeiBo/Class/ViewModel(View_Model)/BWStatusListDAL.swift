//
//  BWStatusListDAL.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/27.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import Foundation

/**
 DAL - Data Access Layer 数据访问层
 使命: 负责处理数据库和网络数据,给 ListViewModel 返回微博数据: [字典]数组
 */

/// 微博数据访问类
class BWStatusListDAL {
    
    class func loadStatus(since_id: Int64 = 0, max_id: Int64 = 0, completion: @escaping (_ list: [[String: Any]]?, _ isSuccess: Bool) -> ()) {
        // 获取当前登录用户ID
        guard let userId = BWNetworkManager.shared.userAccount.uid else {
            return
        }
        
        // 1. 检查本地数据,如果有,直接返回;没有,则从网络加载数据
        let array = BWSQLiteManager.shared.loadStatus(userId: userId, since_id: since_id, max_id: max_id)
        // 判断数组元素的数量,因为没有数据时返回的是空数组[]
        if array.count > 0 {
            completion(array, true)
            return
        }
        
        // 2. 加载网络数据
        BWNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            // 判断网络请求是否成功
            if !isSuccess {
                completion(nil, false)
                return
            }
            
            guard let list = list else {
                completion(nil, false)
                return
            }
            // 3. 加载完成之后,将网络数据写入本地数据库
            BWSQLiteManager.shared.updateStatus(userId: userId, array: list)
            
            // 4. 返回网络数据
            completion(list, isSuccess)
        }
    }
}
