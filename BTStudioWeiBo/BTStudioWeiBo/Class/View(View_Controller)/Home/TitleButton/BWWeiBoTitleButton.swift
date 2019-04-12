//
//  BWWeiBoTitleButton.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/12.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

class BWWeiBoTitleButton: UIButton {
    
    /// 重载构造函数
    ///
    /// - Parameter title: 标题
    ///
    /// 1. title 为nil,就显示为"首页"
    /// 2. title 不为nil,就显示 title 和箭头图标
    init(title: String?) {
        super.init(frame: CGRect())
        
        /// 判断title是否为nil
        if let title = title {
            setTitle(title + " ", for: .normal)
            setImage(UIImage(named: "navigationbar_arrow_down"), for: .normal)
            setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        } else {
            setTitle("首页", for: .normal)
        }
        
        // 设置字体和颜色
        titleLabel?.font = UIFont.systemFont(ofSize: 17)
        setTitleColor(UIColor.darkGray, for: .normal)
        setTitleColor(UIColor.black, for: .selected)
        adjustsImageWhenHighlighted = false
        showsTouchWhenHighlighted = false
        
        /**
         Tips: return title and image views. will always create them if necessary. always returns nil for system buttons
         需要调用一下titleLabel或者imageView才会创建
         */
        // 该行代码只为创建imageView
        imageView?.backgroundColor = UIColor.clear

        sizeToFit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 重新布局子视图
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 判断 label 和 imageView 是否同时存在
        guard let titleLabel = titleLabel,
            let imageView = imageView else {
            return
        }

        // 调整子控件位置
        // 1. 将lable向左移动imageView的宽度
        titleLabel.frame = titleLabel.frame.offsetBy(dx: -imageView.bounds.width, dy: 0)
        // 2. 将imageView向右移动label的宽度
        imageView.frame = imageView.frame.offsetBy(dx: titleLabel.bounds.width, dy: 0)
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
