//
//  BWStatusCell.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/13.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/// 微博Cell
class BWStatusCell: UITableViewCell {
    
    /// 微博视图模型
    var viewModel: BWStatusViewModel? {
        didSet {
            // 用户头像
            iconImageView.cz_setImage(urlString: viewModel?.status.user?.profile_image_url, placeholderImage: UIImage(named: "avatar_default_big"), isAvatar: true)
            // 昵称
            nameLabel.text = viewModel?.status.user?.screen_name
            // 会员图标
            memberIconImageView.image = viewModel?.memberIcon
            // 认证图标
            vipIconImageView.image = viewModel?.vipIcon
            // 微博正文
            statusLabel.text = viewModel?.status.text
            
            // 底部工具栏(转发/评论/点赞 数量)
            toolBar.viewModel = viewModel
            
            // 设置配图地址
//            pictureView.urls = viewModel?.status.pic_urls
            // FIXME: 测试代码
            if let count = viewModel?.status.pic_urls?.count {
                if count > 4 {
                    viewModel?.status.pic_urls?.removeSubrange(4..<count)
                    pictureView.urls = viewModel?.status.pic_urls
                } else {
                    pictureView.urls = viewModel?.status.pic_urls
                }
            }
            
            // 设置配图视图的高度
            pictureView.heightConstraint.constant = viewModel?.pictureViewSize.height ?? 0
        }
    }
    
    /// 头像
    @IBOutlet weak var iconImageView: UIImageView!
    
    /// 昵称
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 会员图标
    @IBOutlet weak var memberIconImageView: UIImageView!
    
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    
    /// 认证图标
    @IBOutlet weak var vipIconImageView: UIImageView!
    
    /// 微博正文
    @IBOutlet weak var statusLabel: UILabel!
    
    /// 底部工具栏
    @IBOutlet weak var toolBar: BWStatusToolBar!
    
    /// 微博配图视图
    @IBOutlet weak var pictureView: BWStatusPictureView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
