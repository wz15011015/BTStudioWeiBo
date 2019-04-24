//
//  BWComposeTextView.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/24.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/// 撰写微博的TextView
class BWComposeTextView: UITextView {
    
    private lazy var placeholder = UILabel()
    
    
    deinit {
        // 注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    override func awakeFromNib() {
        setupUI()
    }
    
    
    // MARK: - 监听方法
    
    /// 文本发生变化
    ///
    /// - Parameter notification: 通知
    @objc private func textDidChanged(notification: Notification) {
        // 如果有文本,隐藏placeholder; 否则,显示
        placeholder.isHidden = self.hasText
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
extension BWComposeTextView {
    
    func setupUI() {
        // [⚠️- 谨记知识点 -⚠️]
        /**
         * 1. 通知是一对多的,如果其他控件监听了当前TextView的通知,会正确的收到通知事件,不会有任何影响;
         *
         * 2. 但是如果使用代理方式,即BWComposeTextView成为了UITextView的代理,
         *
         *    self.delegate = self // 自己当自己的代理
         *
         *    则当其他控件成为BWComposeTextView的代理时,
         *    BWComposeTextView就无法收到UITextView的文本变化代理事件,
         *    代理事件会被最后一个设置的代理对象收到.
         *
         * Tips:
         * - 代理只是一个对象的引用,只有最后设置的代理才有效!!
         * - 苹果的日常开发中,代理的监听方式是最多的!
         * - 代理是发生事件时,直接让代理执行协议方法
         *   - 代理的效率高些
         *   - 直接的反向传值
         * - 通知是发生事件时,将通知发送给通知中心,通知中心再"广播"给注册通知的观察者
         *   - 通知效率相对低些
         *   - 如果层次嵌套非常深,可以使用通知传值
         */
        
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChanged(notification:)), name: UITextView.textDidChangeNotification, object: nil)
        
        // 1. 设置占位标签
        placeholder.text = "分享新鲜事..."
        placeholder.font = font
        placeholder.textColor = UIColor.lightGray
        placeholder.frame.origin = CGPoint(x: 5, y: 8)
        placeholder.sizeToFit()
        
        addSubview(placeholder)
    }
}
