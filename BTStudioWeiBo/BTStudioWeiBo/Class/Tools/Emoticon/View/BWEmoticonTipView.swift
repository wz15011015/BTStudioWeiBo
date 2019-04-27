//
//  BWEmoticonTipView.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/27.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit
import pop

/// 选中表情的提示视图
class BWEmoticonTipView: UIImageView {
    
    // MARK: - 私有属性
    /// 提示视图中的按钮,用于显示 表情emoji 或 表情图片
    private lazy var tipButton = UIButton()
    
    /// 之前选择的表情模型
    private var preEmoticon: BWEmoticon?
    
    // MARK: - Public Property
    /// 提示视图当前的表情模型
    var emoticon: BWEmoticon? {
        didSet {
            // 判断表情模型是否变化,无变化则返回
            if emoticon == preEmoticon {
                return
            }
            // 记录当前的表情模型
            preEmoticon = emoticon
            
            // 设置按钮emoji标题或表情图片
            tipButton.setTitle(emoticon?.emoji, for: .normal)
            tipButton.setImage(emoticon?.image, for: .normal)
            
            // 添加表情动画 - 弹力动画的结束时间是根据速度自动计算的,不需要也不能指定动画的duration
            let animation: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            animation.fromValue = 30
            animation.toValue = 8
            animation.springBounciness = 20
            animation.springSpeed = 20
            
            tipButton.layer.pop_add(animation, forKey: nil)
        }
    }
    
    
    // MARK: - 构造函数
    init() {
        let bundle = BWEmoticonManager.shared.bundle
        let image = UIImage(named: "emoticon_keyboard_magnifier", in: bundle, compatibleWith: nil)
        
        super.init(image: image)
        
        // 设置锚点
        layer.anchorPoint = CGPoint(x: 0.5, y: 1.2)
        
        // 添加按钮 - 该按钮用于显示 表情emoji 或 表情图片
        tipButton.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        tipButton.frame = CGRect(x: 0, y: 8, width: 36, height: 36)
        tipButton.center.x = bounds.width * 0.5
        tipButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        addSubview(tipButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
