//
//  UIBarButtonItem+Extension.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/3/30.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /// 创建UIBarButtonItem
    ///
    /// - Parameters:
    ///   - title: title
    ///   - fontSize: fontSize,默认为 16
    ///   - target: target
    ///   - action: action
    ///   - isBack: 是否为返回按钮,如果是返回按钮,则添加返回箭头的图标
    convenience init(title: String, fontSize: CGFloat = 16, target: Any?, action: Selector, isBack: Bool = false) {
        let button: UIButton = UIButton.cz_textButton(title, fontSize: fontSize, normalColor: UIColor.darkGray, highlightedColor: RGBColor(255, 131, 2))
        button.addTarget(target, action: action, for: .touchUpInside)
        
        if isBack {
            let imageName = "navigationbar_back_withtext"
            button.setImage(UIImage(named: imageName), for: .normal)
            button.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        }
        
        // 实例化UIBarButtonItem
        self.init(customView: button)
    }
}
