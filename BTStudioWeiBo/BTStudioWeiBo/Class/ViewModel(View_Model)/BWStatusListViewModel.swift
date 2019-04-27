//
//  BWStatusListViewModel.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/9.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import Foundation
import SDWebImage

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
        
        // 通过数据访问层加载微博数据
        BWStatusListDAL.loadStatus(since_id: since_id, max_id: max_id) { (list, isSuccess) in
        
        // 通过网络加载微博数据
//        BWNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
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
//                print("微博json: \(dict)")
                // 微博模型
                let status = BWStatus()
                status.yy_modelSet(with: dict)
                // 根据 微博模型 创建 微博视图模型
                let viewModel = BWStatusViewModel(status: status)
                // 添加到数组
                array.append(viewModel)
//                print("微博模型: \(viewModel)")
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
//                completion(isSuccess, true)
                self.cacheSingleImage(list: array, finished: completion)
            }
        }
    }
    
    /// 缓存本次微博列表数据中的单张图像
    ///
    /// - Parameter list: 本次微博列表数据
    ///
    /// 应该缓存完所有单张图片,并且修改过配图视图的大小之后,再回调,
    /// 此时,才能保证Cell中等比例显示单张图片
    private func cacheSingleImage(list: [BWStatusViewModel], finished: @escaping (_ isSuccess: Bool, _ shouldRefresh: Bool) -> ()) {
        // 记录图片数据长度
        var length = 0
        
        // 调度组_1: 创建调度组
        let group = DispatchGroup()
        
        
        // 遍历数组,查找为单张图片的微博
        for viewModel in list {
            // 1. 判断图片数量(数量不为1,则继续判断下一个)
            if viewModel.picURLs?.count != 1 {
                continue
            }
            
            // 2. 获取图片模型
            guard let pic = viewModel.picURLs![0].thumbnail_pic,
                let url = URL(string: pic) else {
                    continue
            }
            
            // 3. 下载图片
            /**
             * 1. 方法downloadImage()是SDWebImage库的核心方法;
             * 2. 图像下载完成之后,会自动保存在沙盒中,文件路径是url的MD5;
             * 3. 如果沙盒中已经存在缓存图片,则后续使用SDWebImage通过URL加载图片时,
             *    都会加载本地沙盒中的图片,不会再次发起网络请求,但回调方法依然会调用;
             */
            
            // 调度组_2: 入组
            group.enter()
            
            SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: [], progress: { (_, _, _) in
                
            }, completed: { (image, data, error, _) in
                if let image = image, let imageData = image.pngData() {
                    // data的大小: 在OC中NSData为length属性
                    length += imageData.count
                    
                    // 图片缓存成功,更新配图视图的大小
                    viewModel.updateSingleImageSize(image: image)
                }
                
                // 调度组_3: 出组
                group.leave()
            })
        }
        
        // 调度组_4: 调度组监听方法
        group.notify(queue: DispatchQueue.main) {
            print("所有单张图片缓存完成,数据大小: \(length)")
            // 执行闭包回调
            finished(true, true)
        }
    }
}
