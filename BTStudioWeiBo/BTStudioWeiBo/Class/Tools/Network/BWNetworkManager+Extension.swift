//
//  BWNetworkManager+Extension.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/9.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import Foundation

// MARK: - 封装新浪微博的请求方法
extension BWNetworkManager {
    
    /// 加载微博数据字典数组
    ///
    /// - Parameters:
    ///   - since_id: 返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
    ///   - max_id: 则返回ID小于或等于max_id的微博，默认为0。
    ///   - completion: 完成回调 [list: 微博字典数据, isSuccess: 是否成功]
    func statusList(since_id: Int64 = 0, max_id: Int64 = 0, completion: @escaping (_ list: [[String: Any]]?, _ isSuccess: Bool) -> ()) {
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        let parameters = ["since_id": since_id, "max_id": max_id > 0 ? max_id - 1 : 0]
        
        tokenRequest(method: .GET, URLString: urlString, parameters: parameters) { (json, isSuccess) in
//            print("json: \(json.debugDescription)")
            
            // 从json中获取statuses字典数组
            let dict = json as? NSDictionary
            // 如果as?失败,则result为nil
            let result = dict?["statuses"] as? [[String: Any]]
            
            completion(result, isSuccess)
        }
    }
    
    /// 返回微博未读数量
    ///
    /// - Parameter completion: 完成回调
    func unreadCount(completion: @escaping (_ count: Int) -> ()) {
        guard let uid = uid else {
            return
        }
        let urlString = "https://rm.api.weibo.com/2/remind/unread_count.json"
        let parameter = ["uid": uid]
        
        tokenRequest(method: .GET, URLString: urlString, parameters: parameter) { (json, isSuccess) in
//            print("unread: \(json.debugDescription)")
            
            let dict = json as? [String: Any]
            let count = dict?["status"] as? Int
            completion(count ?? 0)
        }
    }
}
