//
//  BWUserAccount.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/10.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/// 用户账户模型
class BWUserAccount: NSObject {
    
    /// 访问令牌
    var access_token: String?
    
    /// 用户ID
    var uid: String?
    
    /// 过期时间(单位:秒数)
    var expires_in: TimeInterval = 0
    
    override var description: String {
        return yy_modelDescription()
    }
}
