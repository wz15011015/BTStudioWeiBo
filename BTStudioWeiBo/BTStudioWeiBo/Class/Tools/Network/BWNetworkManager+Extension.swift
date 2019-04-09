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
    /// - Parameter completion: 完成回调 [list: 微博字典数据, isSuccess: 是否成功]
    func statusList(completion: @escaping (_ list: [[String: Any]]?, _ isSuccess: Bool) -> ()) {
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        tokenRequest(method: .GET, URLString: urlString, parameters: nil) { (json, isSuccess) in
//            print("json: \(json.debugDescription)")
            
            // 从json中获取statuses字典数组
            let dict = json as? NSDictionary
            // 如果as?失败,则result为nil
            let result = dict?["statuses"] as? [[String: Any]]
            
            completion(result, isSuccess)
        }
    }
}
