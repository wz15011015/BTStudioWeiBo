//
//  BWEmoticonToolbar.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/25.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/// 表情键盘输入视图中的底部工具栏
class BWEmoticonToolbar: UIView {
    
    /// 底部约束
    @IBOutlet weak var bottom: NSLayoutConstraint!

    
    override func awakeFromNib() {
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 布局子控件
        let count = subviews.count
        let w = bounds.width / CGFloat(count)
        let rect = CGRect(x: 0, y: 0, width: w, height: bounds.height)
        
        for (index, view) in subviews.enumerated() {
            view.frame = rect.offsetBy(dx: w * CGFloat(index), dy: 0)
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

// MARK: - 设置界面
private extension BWEmoticonToolbar {
    
    func setupUI() {
        if Is_iPhone_X_Series {
            bottom.constant = CGFloat(TabBarAddedHeight())
        }
        
        // 根据表情包的分组名称设置按钮
        let manager = BWEmoticonManager.shared
        for package in manager.packages {
            let button = UIButton()
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.setTitle(package.groupName, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.setTitleColor(.darkGray, for: .highlighted)
            button.setTitleColor(.darkGray, for: .selected)
            
            // 设置按钮图片
            let imageName = "compose_emotion_table_\(package.bgImageName ?? "")_normal"
            let imageNameHighlight = "compose_emotion_table_\(package.bgImageName ?? "")_selected"
            
            var image = UIImage(named: imageName, in: manager.bundle, compatibleWith: nil)
            var imageHighlight = UIImage(named: imageNameHighlight, in: manager.bundle, compatibleWith: nil)
            // 拉伸图片
            if let size = image?.size {
                let inset = UIEdgeInsets(top: size.height * 0.5, left: size.width * 0.5, bottom: size.height * 0.5, right: size.width * 0.5)
                image = image?.resizableImage(withCapInsets: inset)
                imageHighlight = imageHighlight?.resizableImage(withCapInsets: inset)
            }
            
            button.setBackgroundImage(image, for: .normal)
            button.setBackgroundImage(imageHighlight, for: .highlighted)
            button.setBackgroundImage(imageHighlight, for: .selected)
            
            button.sizeToFit()
            
            addSubview(button)
        }
    }
}
