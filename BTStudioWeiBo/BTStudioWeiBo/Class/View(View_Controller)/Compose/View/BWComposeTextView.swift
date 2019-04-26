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
    
    /// 占位文字标签label
    private lazy var placeholder = UILabel()
    
    /// 返回textView属性文本对应的纯文本字符串 (将图片属性文本转换成纯文本 [哈哈])
    var emoticonText: String {
        // 1. 获取textView的属性文本
        guard let attriString = attributedText else { return "" }
        
        // 2. 需要获得属性文本中的图片属性文本
        var text = String()
        // 遍历属性
        attriString.enumerateAttributes(in: NSRange(location: 0, length: attriString.length), options: []) { (dict, range, _) in
            // 如果字典中包含"NSAttachment"键,说明是图片属性文本,否则是纯文本
            if let attachment = dict[NSAttributedString.Key.attachment] as? BWEmoticonAttachment {
                text += attachment.chs ?? ""
            } else {
                let subStr = (attriString.string as NSString).substring(with: range)
                
                text += subStr
            }
        }
        
        // 3. 返回纯文本
        return text
    }
    
    
    // MARK: - Life Cycle
    
    deinit {
        // 注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    override func awakeFromNib() {
        setupUI()
    }
    
    
    // MARK: - 监听方法
    
    /// 文本发生变化
    @objc private func textDidChanged() {
        // 如果有文本,隐藏placeholder; 否则,显示
        placeholder.isHidden = hasText
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
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChanged), name: UITextView.textDidChangeNotification, object: nil)
        
        // 1. 设置占位标签label
        placeholder.text = "分享新鲜事..."
        placeholder.font = font
        placeholder.textColor = UIColor.lightGray
        placeholder.frame.origin = CGPoint(x: 5, y: 8)
        placeholder.sizeToFit()
        
        // 2. 添加占位标签label
        addSubview(placeholder)
    }
}

// MARK: - 表情键盘相关
extension BWComposeTextView {
    
    /// 向文本视图插入表情符号
    ///
    /// - Parameter emoticon: 选中的表情模型,为nil表示删除
    func insertEmoticon(emoticon: BWEmoticon?) {
        // 1. emoticon为nil,表示删除
        guard let emoticon = emoticon else {
            // 删除文本
            deleteBackward()
            
            return
        }
        
        // 2. emoji 字符串
        if let emoji = emoticon.emoji, let textRange = selectedTextRange {
            replace(textRange, withText: emoji)
            
            return
        }
        
        /**
         * 所有的排版系统中,几乎都有一个共同的特点,即:插入的字符的显示
         * 是跟随前一个字符的属性,但是本身没有'属性'.
         */
        // 3. 图片表情
        let imageText = emoticon.imageText(font: font!)
        
        // 3.1 获取当前textView的属性文本
        let attriStrM = NSMutableAttributedString(attributedString: attributedText)
        // 3.2 将图像的属性文本插入到当前的光标位置
        attriStrM.replaceCharacters(in: selectedRange, with: imageText)
        
        // 3.3 重新设置属性文本
        // 记录光标位置
        let cursorRange = selectedRange
        
        // 设置文本
        attributedText = attriStrM
        
        // 恢复光标位置
        // cursorRange.length是选中字符的长度,插入文本后,应该为0
        selectedRange = NSMakeRange(cursorRange.location + 1, 0)
        
        // 4. 让代理执行文本变化的方法
        delegate?.textViewDidChange?(self)
        textDidChanged()
    }
}
