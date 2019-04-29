//
//  BWStatusCell.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/13.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/// 微博Cell协议
/**
 协议方法如果需要设置成可选的,则:
 - 需要遵守 NSObjectProtocol 协议
 - 协议需要是 @objc
 - 方法需要 @objc optional
 */
@objc protocol BWStatusCellDelegagte: NSObjectProtocol {
    
    /// 选中URL的代理方法
    ///
    /// - Parameters:
    ///   - cell: 微博Cell
    ///   - urlString: URL字符串
    @objc optional func statusCellDidSelectedURLString(cell: BWStatusCell, urlString: String)
}


/// 微博Cell
class BWStatusCell: UITableViewCell {
    
    /// 代理
    weak var delegate: BWStatusCellDelegagte?
    
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
//            statusLabel.text = viewModel?.status.text
            statusLabel.attributedText = viewModel?.statusAttrText
            // 时间
//            timeLabel.text = viewModel?.status.created_at
            timeLabel.text = viewModel?.status.createDate?.cz_dateDescription
            // 微博来源
//            sourceLabel.text = viewModel?.sourceStr
            sourceLabel.text = viewModel?.status.source
            
            // 底部工具栏(转发/评论/点赞 数量)
            toolBar.viewModel = viewModel
            
            // 设置配图视图的视图模型
            pictureView.viewModel = viewModel
            
            // 设置配图视图的高度
            pictureView.heightConstraint.constant = viewModel?.pictureViewSize.height ?? 0
            
            // 设置被转发微博正文
//            retweetedLabel?.text = viewModel?.retweetedText
            retweetedLabel?.attributedText = viewModel?.retweetedAttrText
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
    @IBOutlet weak var statusLabel: BWLabel!
    
    /// 底部工具栏
    @IBOutlet weak var toolBar: BWStatusToolBar!
    
    /// 微博配图视图
    @IBOutlet weak var pictureView: BWStatusPictureView!
    
    /// 被转发微博的正文 (原创微博没有此控件)
    @IBOutlet weak var retweetedLabel: BWLabel?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // 高级优化:
        // 1. 离屏渲染 - 异步绘制
//        self.layer.drawsAsynchronously = true
        
        // 2. 栅格化 - 异步绘制之后,会生成一张独立的图片,Cell在屏幕上滚动的时候,本质上滚动的是这张图片
        // Cell的优化要尽量减少图层的数量,相当于只有一层!
        // 停止滚动后,可以接收监听事件
//        self.layer.shouldRasterize = true
        
        // 使用栅格化,必须注意指定分辨率
//        self.layer.rasterizationScale = UIScreen.main.scale
        
        /**
         * Tips:
         * - 如果检测到Cell滚动时的性能已经很好了,就不需要离屏渲染了;
         *   - 离屏渲染需要在GPU / CPU之间快速的切换;
         *   - 耗电会厉害;
         */
        
        
        // 设置微博正文label(BWLabel)的代理
        statusLabel.delegate = self
        retweetedLabel?.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


// MARK: - BWLabel协议方法
extension BWStatusCell: BWLabelDelegate {
    
    func labelDidSelectedLinkText(label: BWLabel, text: String) {
        // 判断是否为URL
        if text.hasPrefix("http") {
            /**
             statusCellDidSelectedURLString后面插入 ? 表示:
             - 如果代理没有实现协议方法,就什么都不做
             
             假如插入 ! ,当代理方法没有实现时,仍会强行执行方法,导致崩溃!
             */
            delegate?.statusCellDidSelectedURLString?(cell: self, urlString: text)
        }
    }
}
