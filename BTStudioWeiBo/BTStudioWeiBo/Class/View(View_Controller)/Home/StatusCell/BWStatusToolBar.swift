//
//  BWStatusToolBar.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/13.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/// 微博底部工具栏
class BWStatusToolBar: UIView {
    
    /// 微博视图模型
    var viewModel: BWStatusViewModel? {
        didSet {
            retweetedButton.setTitle(viewModel?.retweetedStr, for: .normal)
            commentButton.setTitle(viewModel?.commentStr, for: .normal)
            likeButton.setTitle(viewModel?.liekStr, for: .normal)
        }
    }
    
    /// 转发按钮
    @IBOutlet weak var retweetedButton: UIButton!
    
    /// 评论按钮
    @IBOutlet weak var commentButton: UIButton!
    
    /// 点赞按钮
    @IBOutlet weak var likeButton: UIButton!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
