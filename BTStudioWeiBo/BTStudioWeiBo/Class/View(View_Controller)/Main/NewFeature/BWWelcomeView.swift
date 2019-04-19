//
//  BWWelcomeView.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/12.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit
import SDWebImage

/// 欢迎视图
class BWWelcomeView: UIView {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // 该方法只是刚刚从xib加载二进制文件将视图数据加载完成,
        // 还没有和代码连线建立起关系,所以开发时,千万不要在这个方法中处理UI
    }
    
    override func awakeFromNib() {
        // 设置头像
        guard let urlString = BWNetworkManager.shared.userAccount.avatar_large,
            let url = URL(string: urlString) else {
                return
        }
        iconImageView.setImageWith(url, placeholderImage: UIImage(named: "visitordiscover_image_profile"))
        
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.cornerRadius = iconImageView.bounds.width * 0.5
    }
    
    class func welcomeView() -> BWWelcomeView {
        let nib = UINib(nibName: "BWWelcomeView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! BWWelcomeView
        
        // 从xib加载的视图,默认为xib的大小,在此处需要调整一下
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    /// 自动布局系统更新约束完成后,会自动调用此方法
//    override func layoutSubviews() {
//        super.layoutSubviews()
//    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        /**
         视图使用自动布局时,只是设置了约束
         - 当视图被添加到窗口上时,根据父视图的大小来计算约束值,更新控件位置
         */
        
        // 调用layoutIfNeeded()时,会按照当前的约束来直接更新控件位置
        // 此时更新控件位置后,即为xib中布局的位置
        self.layoutIfNeeded()
        
        // 调整约束
        bottomConstraint.constant = bounds.size.height - 220
        
        // 如果控件的frame还没有计算好,调用layoutIfNeeded(),则所有的约束会一起动画!
        UIView.animate(withDuration: 1.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            // 更新约束,更新控件位置
            self.layoutIfNeeded()
        }) { (completion) in
            UIView.animate(withDuration: 1.4, animations: {
                self.tipLabel.alpha = 1.0
            }) { (_) in
                self.removeFromSuperview()
            }
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
