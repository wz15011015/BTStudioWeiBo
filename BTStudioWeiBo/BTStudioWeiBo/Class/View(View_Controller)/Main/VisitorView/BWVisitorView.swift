//
//  BWVisitorView.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/3.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/// 访客视图
class BWVisitorView: UIView {
    
    /// 访客视图的信息字典
    ///
    /// 提示: 如果是首页,则imageName = ""
    var visitorInfo: [String: String]? {
        didSet {
            guard let imageName = visitorInfo?["imageName"],
                let message = visitorInfo?["message"] else {
                    return
            }
            
            // 设置消息
            tipLabel.text = message
            
            // 设置图像
            if imageName == "" {
                startAnimation()
                return
            }
            
            iconView.image = UIImage(named: imageName)
            
            // 其他控制器的访客视图不需要显示小房子/遮罩视图
            houseIconView.isHidden = true
            maskIconView.isHidden = true
        }
    }
    
    
    // MARK: - 私有控件
    /// 图像视图
    private lazy var iconView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    
    /// 遮罩图像 - 不要使用maskView
    private lazy var maskIconView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    
    /// 小房子
    private lazy var houseIconView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    
    /// 提示标签
    private lazy var tipLabel: UILabel = UILabel.cz_label(withText: "关注一些人，回这里看看有什么惊喜", fontSize: 14, color: UIColor.darkGray)
    
    /// 注册按钮
    private lazy var registerButton: UIButton = UIButton.cz_textButton("注册", fontSize: 16, normalColor: UIColor.orange, highlightedColor: UIColor.black, backgroundImageName: "common_button_white_disable")
    
    /// 登录按钮
    private lazy var loginButton: UIButton = UIButton.cz_textButton("登录", fontSize: 16, normalColor: UIColor.darkGray, highlightedColor: UIColor.black, backgroundImageName: "common_button_white_disable")
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 旋转动画
    private func startAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = Double.pi
        animation.repeatCount = HUGE
        animation.duration = 15
        
        // 动画完成后不删除, 如果 iconView 被释放,则动画会一起销毁!
        animation.isRemovedOnCompletion = false
        
        iconView.layer.add(animation, forKey: nil)
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
extension BWVisitorView {
    
    private func setupUI() {
        // 在开发的时候,如果能够使用颜色,就不要使用图片,使用颜色效率会更高!
        backgroundColor = UIColor.cz_color(withRed: 237, green: 237, blue: 237)
        
        // 1. 添加控件
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(houseIconView)
        addSubview(tipLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        // 提示文本居中
        tipLabel.textAlignment = .center
        
        // 2. 取消 autoresizing
        for view in subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // 3. iOS系统原生的自动布局
        let margin: CGFloat = 20.0
        // 图像视图
        addConstraint(NSLayoutConstraint(item: iconView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: -60))
        
        // 遮罩图像 (VFL)
        /**
         VFL 可视化格式语言:
         H  水平方向
         V  竖直方向
         |  边界
         [] 包含控件的名称字符串,对应关系在 views 字典中定义
         () 定义控件的宽/高,可以在 metrics 中指定
         
         options: []
         metrics: 约束数值字典 [String: 数值]
         views: 视图字典 [String: 子视图], 用来定义 VFL 中的控件名称和实际名称映射关系
         
         提示: VFL通常用于连续参照关系,如果遇到居中对齐,通常直接使用参照
         */
        let viewDict = ["maskIconView": maskIconView,
                        "registerButton": registerButton]
        let metrics = ["spacing": -60]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[maskIconView]-0-|", options: [], metrics: nil, views: viewDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[maskIconView]-(spacing)-[registerButton]", options: [], metrics: metrics, views: viewDict))
        
        
        // 小房子
        addConstraint(NSLayoutConstraint(item: houseIconView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: houseIconView,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: -5))
        
        // 提示标签
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: margin))
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: CGFloat(BW_Width - 40)))
        
        // 注册按钮
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .left,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .left,
                                         multiplier: 1.0,
                                         constant: 30))
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: margin))
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 100))
        
        // 登录按钮
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .right,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .right,
                                         multiplier: 1.0,
                                         constant: -30))
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: margin))
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: registerButton,
                                         attribute: .width,
                                         multiplier: 1.0,
                                         constant: 0))
    }
}
