//
//  BWNavigationBar.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/1.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/// 自定义NavigationBar,继承自UINavigationBar
///
/// 用以解决iOS 11.0及以后系统中导航栏向上偏移20的问题
class BWNavigationBar: UINavigationBar {
    /**
     * iOS 11.0及以后,UINavigationBar的结构:
     *
     *              UINavigationBar
     *                     ↓
     *        --------------------------
     *        |                        |
     *        ↓                        ↓
     * _UIBarBackground   _UINavigationBarContentView
     *
     *
     * 1> _UIBarBackground: 导航栏背景
     *    frame:(0, 0, 414, 64)
     *    iPhoneX系列frame:(0, 0, 414, 88)
     *
     * 2> _UINavigationBarContentView: 导航栏内容 (放置了标题Label及导航栏按钮)
     *    frame: (0, 20, 414, 44)
     *    iPhoneX系列frame: (0, 44, 414, 44)
     *
     */
    
    /// 重写layoutSubviews布局方法
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if #available(iOS 11.0, *) {
            for subview in subviews {
                let subviewClassName = NSStringFromClass(subview.classForCoder)
                if subviewClassName == "_UIBarBackground" { // 导航栏背景
                    subview.frame = bounds
                } else if subviewClassName == "_UINavigationBarContentView" { // 导航栏内容
                    // 向下调整20,其高度仍保持44
                    let offsetY = CGFloat(20 + (Is_iPhone_X_Series ? NavBarAddedHeight() : 0))
                    var frame = subview.frame
                    frame.origin.y = offsetY
                    subview.frame = frame
                }
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
