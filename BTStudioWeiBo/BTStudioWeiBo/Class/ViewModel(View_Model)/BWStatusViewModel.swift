//
//  BWStatusViewModel.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/13.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/**
 如果没有继承任何父类,且希望在开发时输出调试信息,则需要:
 - 遵守 CustomStringConvertible 协议
 - 实现计算型属性: description
 */

/**
 关于表格视图的优化:
 - 尽量少计算,所有需要的素材都提前计算好!
 - 控件上尽量不要设置圆角半径,所有图像渲染的属性都要注意!
 - 不要动态创建控件,所有控件都需要提前创建好,在显示的时候,只需要根据数据来隐藏/显示!
 - Cell 中控件的层次越少越好,数量越少越好!
 - 要测量,不要猜测!
 */

/// 单条微博数据 视图模型
class BWStatusViewModel: CustomStringConvertible {
    
    /// 微博模型
    var status: BWStatus
    
    /// 会员图标 - 存储型属性,用内存空间换CPU消耗
    var memberIcon: UIImage?
    
    /// 认证图标
    var vipIcon: UIImage?
    
    /// 转发文字
    var retweetedStr: String?
    
    /// 评论文字
    var commentStr: String?
    
    /// 点赞文字
    var liekStr: String?
    
    /// 配图视图大小
    var pictureViewSize: CGSize = CGSize()
    
    /// 如果是转发微博,则该微博一定没有图片
    var picURLs: [BWStatusPicture]? {
        // 如果是转发微博,则返回被转发微博的配图
        // 如果不是转发微博,则返回原创微博的配图
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    
    /// 被转发微博的文字
    var retweetedText: String?
    
    
    var description: String {
        return status.description
    }
    
    
    /// 构造函数
    ///
    /// - Parameter model: 微博模型
    init(status model: BWStatus) {
        self.status = model
        
        // 会员等级 0 - 6
        if let mbrank = model.user?.mbrank {
            if mbrank > 0 && mbrank < 7 {
                let imageName = "common_icon_membership_level\(model.user?.mbrank ?? 1)"
                memberIcon = UIImage(named: imageName)
            }
        }
        
        // 认证图标
        if let verified_type = model.user?.verified_type {
            switch verified_type {
            case 0:
                vipIcon = UIImage(named: "avatar_vip")
            case 1, 2, 3, 5:
                vipIcon = UIImage(named: "avatar_enterprise_vip")
            case 220:
                vipIcon = UIImage(named: "avatar_grassroot")
            default:
                break
            }
        }
        
        // 设置转发/评论/赞数量
        retweetedStr = countString(count: model.reposts_count, defaultString: "转发")
        commentStr = countString(count: model.comments_count, defaultString: "评论")
        liekStr = countString(count: model.attitudes_count, defaultString: "赞")
        
        // 计算配图视图大小
        // 有原创的就计算原创的,有转发的就计算转发的
        pictureViewSize = calcPictureViewSize(picturesCount: picURLs?.count)
        
        // 被转发微博的文字
        let userName = "@" + (model.retweeted_status?.user?.screen_name ?? "") + ": "
        retweetedText = userName + (model.retweeted_status?.text ?? "")
    }
    
    
    /// 使用单个图片,更新配图视图的大小
    ///
    /// - Parameter image: 单张图片
    func updateSingleImageSize(image: UIImage) {
        var size = image.size
        size.height += CGFloat(WBStatusPictureViewOutterMargin)
        
        pictureViewSize = size
    }
    
    /// 计算指定数量的图片对应的配图视图的大小
    ///
    /// - parameter count: 配图数量
    ///
    /// - Returns: 配图视图的大小
    private func calcPictureViewSize(picturesCount count: Int?) -> CGSize {
        guard let count = count else {
            return CGSize()
        }
        if count == 0 {
            return CGSize()
        }
        
        // 1. 计算配图视图的宽度
        
        // 2. 计算高度
        // 根据数量计算行数
        let row = ((count - 1) / 3) + 1
        
        let picturesHeight = Double((row - 1)) * WBStatusPictureViewInnerMargin
        let picturesMarginHeight = Double(row) * WBStatusPictureItemWidth
        let height = WBStatusPictureViewOutterMargin + picturesMarginHeight + picturesHeight
        
        return CGSize(width: WBStatusPictureViewWidth, height: height)
    }
    
    /// 给定一个数字,返回对应的描述结果
    ///
    /// - Parameters:
    ///   - count: 数字
    ///   - defaultString: 默认字符串 转发/评论/赞
    /// - Returns: 描述结果
    private func countString(count: Int, defaultString: String) -> String {
        if count == 0 {
            return defaultString
        }
        if count < 10000 {
            return "\(count)"
        }
        return String(format: "%.1f 万", Double(count) / 10000)
    }
}
