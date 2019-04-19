//
//  BWComposeTypeView.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/18.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit
import pop

class BWComposeTypeView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// 关闭按钮
    @IBOutlet weak var closeButton: UIButton!
    
    /// 返回上一页按钮
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var closeButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var closeButtonCenterX: NSLayoutConstraint!
    @IBOutlet weak var backButtonCenterX: NSLayoutConstraint!
    
    private let buttonsInfo = [["imageName": "tabbar_compose_idea", "title": "文字", "clsName": "BWComposeViewController"],
                               ["imageName": "tabbar_compose_photo", "title": "照片/视频"],
                               ["imageName": "tabbar_compose_weibo", "title": "长微博"],
                               ["imageName": "tabbar_compose_lbs", "title": "签到"],
                               ["imageName": "tabbar_compose_review", "title": "点评"],
                               ["imageName": "tabbar_compose_more", "title": "更多", "actionName":"clickMore"],
                               ["imageName": "tabbar_compose_friend", "title": "好友圈"],
                               ["imageName": "tabbar_compose_wbcamera", "title": "微博相机"],
                               ["imageName": "tabbar_compose_music", "title": "音乐"],
                               ["imageName": "tabbar_compose_shooting", "title": "拍摄"]
                              ]
    
    /// 完成回调
    private var completionCallback: ((_ clsName: String?) -> ())?
    
    
//    override init(frame: CGRect) {
//        super.init(frame: UIScreen.main.bounds)
//
//        backgroundColor = UIColor.brown
//    }
    
//    required init?(coder aDecoder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
//    }
    
    /// 实例化方法
    ///
    /// - Returns: BWComposeTypeView
    class func composeTypeView() -> BWComposeTypeView {
        let nib = UINib(nibName: "BWComposeTypeView", bundle: nil)
        
        // 从 xib 加载视图完成后,就会调用awakeFromNib()
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! BWComposeTypeView
        
        // 从xib加载的视图,默认为xib的大小,在此处需要调整一下
        view.frame = UIScreen.main.bounds
        
        view.setupUI()
        
        return view
    }
    
    
    /// 显示当前视图
    func show(completion: @escaping (_ clsName: String?) -> ()) {
        // 记录闭包
        completionCallback = completion
        
        // 1. 将视图加到 根视图控制器 的view上
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        rootVC.view.addSubview(self)
        
        // 2. 动画效果
        showCurrentView()
    }
    
    
    // MARK: - 监听方法
    
    /// 点击了按钮
    @objc private func clickButton(sender: BWComposeTypeButton) {
        print("点击了: \(sender.titleLabel.text ?? "")")
        
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let pageView = scrollView.subviews[page]
        
        for button in pageView.subviews {
            // 1. 缩放动画
            let scaleAni: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            // x,y 在系统中使用 CGPoint 表示,如果要转换成id,需要使用NSValue包装
            let scale = sender == button ? 1.4 : 0.6
            scaleAni.toValue = NSValue(cgPoint: CGPoint(x: scale, y: scale))
            scaleAni.duration = 0.5
            button.pop_add(scaleAni, forKey: nil)
            
            // 2. 渐变动画 - 再添加一个动画会自动形成动画组
            let alphaAni: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            alphaAni.toValue = 0.2
            alphaAni.duration = 0.5
            button.pop_add(alphaAni, forKey: nil)
            
            alphaAni.completionBlock = { _, _ in
                // 执行闭包回调
                self.completionCallback?(sender.clsName)
            }
            
            // 监听动画执行的进程
//            let aniProperty = POPAnimatableProperty.property(withName: "alpha") { (animationProperty) in
//                animationProperty?.readBlock = { (obj, values) in
////                    guard let values = values else {
////                        return
////                    }
////                    let progress: Int8 = 0
////                    let value = NSValue(bytes: values, objCType: &progress)
////                    print("动画进度: \(value)")
//                }
//            } as! POPAnimatableProperty
//            alphaAni.property = aniProperty
        }
    }
    
    /// 关闭视图
    @IBAction func close() {
        hideButtons()
    }
    
    /// 点击了"更多"按钮
    @objc func clickMore() {
        // 将scrollView滚动到第二页
        scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: true)
        
        // 处理底部按钮,让两个按钮分开
        let margin = scrollView.bounds.width / 6
        closeButtonCenterX.constant += margin
        backButtonCenterX.constant -= margin
        
        backButton.isHidden = false
        backButton.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
            self.backButton.alpha = 1
        }
    }
    
    /// 点击了返回按钮
    @IBAction func clickBackButton() {
        // 将scrollView滚动到第一页
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        // 让两个按钮合并
        closeButtonCenterX.constant = 0
        backButtonCenterX.constant = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
            self.backButton.alpha = 0
        }) { (_) in
            self.backButton.isHidden = true
            self.backButton.alpha = 1
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


// MARK: - 动画实现
private extension BWComposeTypeView {
    
    // MARK: - 隐藏动画
    /// 弹力隐藏按钮
    func hideButtons() {
        // 1. 根据contentOffset判断当前显示第几页
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        // 放置按钮的视图
        let pageView = scrollView.subviews[page]
        
        // 2. 遍历所有按钮
        for (i, button) in pageView.subviews.reversed().enumerated() {
            let ani: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            
            // 设置动画属性
            ani.fromValue = button.center.y
            ani.toValue = button.center.y + 400
            ani.springSpeed = 6
            ani.beginTime = CACurrentMediaTime() + Double(i) * 0.025
            
            button.pop_add(ani, forKey: nil)
            
            // 监听第一个按钮的动画完成事件,第一个按钮是最后一个执行动画的
            if i == pageView.subviews.count - 1 {
                ani.completionBlock = { (_, _) -> (Void) in
                    self.hideCurrentView()
                }
            }
        }
    }
    
    /// 隐藏当前视图(self)
    func hideCurrentView() {
        // 1. 创建动画
        let ani: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        ani.fromValue = 1
        ani.toValue = 0
        ani.duration = 0.25
        
        // 2. 添加动画到视图
        pop_add(ani, forKey: nil)
        
        // 3. 动画完成的监听方法
        ani.completionBlock = { _, _ in
            self.removeFromSuperview()
        }
    }
    
    
    // MARK: - 显示动画
    /// 显示当前视图(self)
    func showCurrentView() {
        // 1. 创建动画
        let ani: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        ani.fromValue = 0
        ani.toValue = 1
        ani.duration = 0.4
        
        // 2. 动画添加到视图
        pop_add(ani, forKey: nil)
        
        // 3. 按钮的动画
        self.showButtons()
    }
    
    /// 弹力显示所有按钮
    func showButtons() {
        // 第一页视图 (放置按钮的视图)
        let pageView0 = scrollView.subviews[0]
        for (i, button) in pageView0.subviews.enumerated() {
            // 创建动画
            let ani: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            
            // 设置动画属性
            ani.fromValue = button.center.y + 300
            ani.toValue = button.center.y
            // 弹力系数,数值越大,弹力越大
            ani.springBounciness = 8
            // 弹力速度
            ani.springSpeed = 9
            // 设置动画启动时间
            ani.beginTime = CACurrentMediaTime() + CFTimeInterval(i) * 0.025
            
            // 添加动画
            button.pop_add(ani, forKey: nil)
        }
    }
}


// MARK: - 设置界面
/// private 让 extension 中的所有方法都是私有的
private extension BWComposeTypeView {
    
    /// 设置界面
    func setupUI() {
        if Is_iPhone_X_Series {
            closeButtonHeight.constant = 80
        }
        
        self.backButton.isHidden = true
        
        // 强行更新布局
        layoutIfNeeded()
        
        // 1. scrollView的设置
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * 2, height: scrollView.bounds.height)
        
        // 2. 按钮的添加
        let rect = scrollView.bounds
        for i in 0...1 {
            // 1. 向 scrollView 添加视图
            let view = UIView(frame: rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0))
            scrollView.addSubview(view)
            
            // 2. 向视图添加按钮
            addButtons(view: view, idx: i * 6)
        }
    }
    
    /// 向视图添加按钮,按钮的索引从 idx 开始
    func addButtons(view: UIView, idx: Int) {
        let count = 6
        // 从idx开始,添加6个按钮
        for i in idx..<(idx + count) {
            if i >= buttonsInfo.count {
                break
            }
            
            let dict = buttonsInfo[i]
            // 获取图片名称和按钮标题
            guard let imageName = dict["imageName"],
                let title = dict["title"] else {
                    return
            }
            // 创建按钮
            let button = BWComposeTypeButton.composeTypeButton(imageName: imageName, title: title)
            // 添加按钮
            view.addSubview(button)
            // 添加监听方法
            if let actionName = dict["actionName"] { // "更多"按钮
                let selector = Selector(actionName)
                button.addTarget(self, action: selector, for: .touchUpInside)
            } else {
                button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
            }
            
            // 设置要展现控制器的类名
            button.clsName = dict["clsName"]
        }
        
        // 布局 (遍历子视图进行布局)
        let btnSize = CGSize(width: 100, height: 100)
        let margin = (view.bounds.width - 3 * btnSize.width) / 4
        for (i, button) in view.subviews.enumerated() {
            let y: CGFloat = i > 2 ? (view.bounds.height - btnSize.height) : 0
            let column = CGFloat(i % 3)
            let x = ((column + 1) * margin) + (column * btnSize.width)
            
            button.frame = CGRect(x: x, y: y, width: btnSize.width, height: btnSize.height)
        }
    }
}
