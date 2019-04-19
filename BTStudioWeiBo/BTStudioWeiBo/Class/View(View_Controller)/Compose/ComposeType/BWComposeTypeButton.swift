//
//  BWComposeTypeButton.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/18.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/// UIControl - 内置了 touchUpInside 事件响应
class BWComposeTypeButton: UIControl {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 点击按钮要展现控制器的类型
    var clsName: String?
    
    
    /// 使用图片名称/文字创建按钮,按钮布局从 xib 加载
    ///
    /// - Parameters:
    ///   - imageName: 图片名称
    ///   - title: 按钮文字
    /// - Returns: 按钮
    class func composeTypeButton(imageName: String, title: String) -> BWComposeTypeButton {
        let nib = UINib(nibName: "BWComposeTypeButton", bundle: nil)
        
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! BWComposeTypeButton
        
        view.imageView.image = UIImage(named: imageName)
        view.titleLabel.text = title
        
        return view
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
