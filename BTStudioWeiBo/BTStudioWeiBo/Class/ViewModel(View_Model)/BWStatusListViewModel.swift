//
//  BWStatusListViewModel.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/9.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import Foundation

/// 上拉刷新的最大次数
private let maxPullUpTryTimes = 3


/// 微博数据列表 视图模型
///
/// 父类的选择:
/// - 如果类需要使用 kvc 或者 字典转模型 设置对象的值时,就需要继承自NSObject
/// - 如果类只是包装一下逻辑代码,则可以不用继承任何父类,好处是更加轻量级
/// - 在OC中,类一律都继承自NSObject即可
///
/// 使命: 负责微博的数据处理
/// - 字典转模型
/// - 下拉/上拉刷新的数据处理
class BWStatusListViewModel {
    
    /// 微博模型数组懒加载
    lazy var statusList: [BWStatusViewModel] = []
    
    /// 上拉刷新错误次数
    private var pullupErrorTimes = 0
    
    
    /// 加载微博列表
    ///
    /// - Parameters:
    ///   - pullUp: 上拉刷新标记
    ///   - completion: 完成回调 [isSuccess: 网络请求是否成功, shouldRefresh: 是否需要刷新]
    func loadStatus(pullUp: Bool, completion: @escaping (_ isSuccess: Bool, _ shouldRefresh: Bool) -> ()) {
        // 判断是否为上拉刷新,则检查上拉刷新次数
        if pullUp && pullupErrorTimes > maxPullUpTryTimes {
            completion(false, false)
            return
        }
        
        // 取出第一条微博的id
        let since_id = pullUp ? 0 : self.statusList.first?.status.id ?? 0
        
        // 上拉刷新,取出数组的最后一条微博的id
        let max_id = pullUp ? self.statusList.last?.status.id ?? 0 : 0
        
        BWNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
//            guard let array = list else {
//                completion(isSuccess)
//                return
//            }
//
//            for dict in array {
//                let status = BWStatus(dictionary: dict)
//                self.statusList.append(status)
//            }
            
            
            if !isSuccess {
                completion(false, false)
                return
            }
            
            // 微博视图模型 数组
            var array: [BWStatusViewModel] = []
            for dict in list ?? [] {
                // 微博模型
                let status = BWStatus()
                status.yy_modelSet(with: dict)
                // 根据 微博模型 创建 微博视图模型
                let viewModel = BWStatusViewModel(status: status)
                // 添加到数组
                array.append(viewModel)
//                print(viewModel)
            }
            
            // 1. 字典转模型
//            guard let array = NSArray.yy_modelArray(with: BWStatus.self, json: list ?? []) as? [BWStatus] else {
//                completion(isSuccess, false)
//                return
//            }
            print("刷新了 \(array.count) 条微博!")
            // 2. 拼接数据
            if pullUp {
                self.statusList = self.statusList + array
            } else {
                self.statusList = array + self.statusList
            }
            
            // 3. 完成回调
            if pullUp && array.count == 0 {
                self.pullupErrorTimes += 1
                completion(isSuccess, false)
            } else {
                completion(isSuccess, true)
            }
        }
    }
}
