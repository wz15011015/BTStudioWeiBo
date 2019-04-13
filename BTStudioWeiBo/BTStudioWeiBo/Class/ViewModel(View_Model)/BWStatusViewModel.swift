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
    }
    
    var description: String {
        return status.description
    }
}
