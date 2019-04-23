//
//  BWLabel.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/23.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/**
 * 1. 使用TextKit接管 Label 的底层实现
 *   - 绘制 textStorage 的文本内容
 *
 * 2. 使用正则表达式过滤 URL
 *   - 设置URL文字的特殊显示
 *
 * 3. 交互
 *
 *
 * - UILabel 默认不能实现文本在垂直方向上顶部对齐,使用 TextKit 可以实现!
 * - 在iOS 7.0之前,要实现类似效果,需要使用 CoreText, 它使用起来异常的繁琐!
 * - YYModel的作者开发了一个框架: YYText,他自己实现了一套渲染系统
 */

@objc
protocol BWLabelDelegate: NSObjectProtocol {
    /// 选中了链接文本
    ///
    /// - Parameters:
    ///   - label: label
    ///   - text: 选中的文本
    @objc optional func labelDidSelectedLinkText(label: BWLabel, text: String)
}


/// TextKit接管的Label
class BWLabel: UILabel {
    
    // MARK: - 公开属性
    
    /// 链接文本的颜色
    public var linkTextColor = UIColor(red: 82 / 255.0, green: 131 / 255.0, blue: 175 / 255.0, alpha: 1.0)
    
    /// 链接文本的背景颜色
    public var selectedBackgroundColor = UIColor(red: 189 / 255.0, green: 206 / 255.0, blue: 221 / 255.0, alpha: 1.0)
    
    /// 点击事件代理
    public weak var delegate: BWLabelDelegate?
    
    
    // MARK: - 懒加载属性
    
    // TextKit的核心对象
    /// 属性文本存储
    private lazy var textStorage = NSTextStorage()
    
    /// 负责文本"字形"的布局
    private lazy var layoutManager = NSLayoutManager()
    
    /// 设定文本绘制的范围
    private lazy var textContainer = NSTextContainer()
    
    /// URL的range数组
    private lazy var linkRanges: [NSRange] = []
    
    /// 用户点击的URL的range (若用户点击位置在一个URL的范围内,则有值)
    private var selectedRange: NSRange?
    
    
    // MARK: - 重写属性
    
    /// 文字
    ///
    /// 一旦内容有变化,就需要让 textStroage响应变化!
    ///
    /// 这里能进一步体会 TextKit 接管底层的实现
    override var text: String? {
        didSet {
            // 更新文本内容并重绘
            updateTextStorage()
        }
    }
    
    override var attributedText: NSAttributedString? {
        didSet {
            // 更新文本内容并重绘
            updateTextStorage()
        }
    }
    
    override var font: UIFont! {
        didSet {
            // 更新文本内容并重绘
            updateTextStorage()
        }
    }
    
    override var textColor: UIColor! {
        didSet {
            // 更新文本内容并重绘
            updateTextStorage()
        }
    }
    
    
    // MARK: - 重写方法
    /// 构造函数
    ///
    /// - Parameter frame: frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareTextSystem()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        prepareTextSystem()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 指定文本绘制的范围 (label有多大,就在哪里绘制)
        textContainer.size = bounds.size
    }
    
    /// 绘制文本
    ///
    /// - Parameter rect: rect
    override func drawText(in rect: CGRect) {
//        super.drawText(in: rect)
        
        
        let range = glyphsRange()
        let offset = glyphsOffset(range)
        
        /**
         * 在 iOS 中绘制工作是类似于油画的,后绘制的内容会把之前绘制的内容覆盖掉.
         * -- 尽量避免使用带透明度的颜色,会严重影响性能!
         */
        // 绘制背景
        layoutManager.drawBackground(forGlyphRange: range, at: offset)
        
        // 绘制字形 (Glyphs 字形)
        layoutManager.drawGlyphs(forGlyphRange: range, at: CGPoint.zero)
    }
    
    
    // MARK: - 交互事件
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1. 获取用户点击位置
        guard let location = touches.first?.location(in: self) else {
            return
        }
        
        // 2. 判断点击位置是否为某个URL的范围,若是,则获取该URL的range
        selectedRange = linkRangeAtLocation(at: location)
        
        // 3. 修改文本的属性,高亮显示URL
        modifySelectedAttribute(true)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1. 获取用户点击位置
        guard let location = touches.first?.location(in: self) else {
            return
        }
        
        if let range = linkRangeAtLocation(at: location) {
            if let selectedRange = selectedRange {
                if !NSEqualRanges(range, selectedRange) {
//                    print("不在URL的范围内")
                    modifySelectedAttribute(false)
                    self.selectedRange = range
                    modifySelectedAttribute(true)
                } else {
//                    print("还在URL的范围内")
                }
            }
        } else {
            modifySelectedAttribute(false)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let selectedRange = selectedRange else {
            return
        }
        
        // 触摸事件结束时,获取点击URL的文本内容,并通知代理
        let text = (textStorage.string as NSString).substring(with: selectedRange)
        delegate?.labelDidSelectedLinkText?(label: self, text: text)
        
        // 恢复URL的显示
        let when = DispatchTime.now() + Double(Int64(0.25 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.modifySelectedAttribute(false)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        modifySelectedAttribute(false)
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}


// MARK: - 设置TextKit核心对象
private extension BWLabel {
    
    /// 准备文本系统
    func prepareTextSystem() {
        // 1. 打开交互功能
        isUserInteractionEnabled = true
        
        textContainer.lineFragmentPadding = 0
        
        // 2. 设置对象的关系
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
    }
    
    /// Update text storage and redraw text
    func updateTextStorage() {
        guard let attributedText = attributedText else {
            return
        }
        
        // 设置换行模式
        let mutableAttriString = addLineBreak(attributedString: attributedText)
        // 匹配处理,以获取匹配结果
        matchLinkRange(attributedString: mutableAttriString)
        // 添加属性
        addLinkAttribute(mutableAttrString: mutableAttriString)
        
        textStorage.setAttributedString(mutableAttriString)
        
        setNeedsDisplay()
    }
    
    /// 字形范围
    ///
    /// - Returns: 范围
    func glyphsRange() -> NSRange {
        return NSMakeRange(0, textStorage.length)
    }
    
    func glyphsOffset(_ range: NSRange) -> CGPoint {
        let rect = layoutManager.boundingRect(forGlyphRange: range, in: textContainer)
        let height = (bounds.height - rect.height) * 0.5
        
        return CGPoint(x: 0, y: height)
    }
    
    /// 判断 点击位置 是否在某一个URL的range范围内.若在,则返回相应URL的range;否则,返回nil
    ///
    /// - Parameter location: 点击位置
    /// - Returns: URL的range
    func linkRangeAtLocation(at location: CGPoint) -> NSRange? {
        if textStorage.length == 0 {
            return nil
        }
        
        // 1. 用户点击位置
        let offset = glyphsOffset(glyphsRange())
        let point = CGPoint(x: offset.x + location.x, y: offset.y + location.y)
        
        // 2. 根据点击位置获取当前点击字符的索引
        let index = layoutManager.glyphIndex(for: point, in: textContainer)
        
        // 3. 判断index是否在URL的range范围内, 如果在,就返回range
        for range in linkRanges {
            if NSLocationInRange(index, range) {
                return range
            }
        }
        return nil
    }
    
    /// 修改点击URL的属性
    ///
    /// - Parameter isSet: 是否重置背景颜色
    func modifySelectedAttribute(_ isSet: Bool) {
        guard let selectedRange = selectedRange else {
            return
        }
        
        var attributes = textStorage.attributes(at: 0, effectiveRange: nil)
        // 前景颜色
        attributes[NSAttributedString.Key.foregroundColor] = linkTextColor
        // 背景颜色
        if isSet {
            attributes[NSAttributedString.Key.backgroundColor] = selectedBackgroundColor
        } else {
            attributes[NSAttributedString.Key.backgroundColor] = UIColor.clear
            self.selectedRange = nil
        }
        
        textStorage.addAttributes(attributes, range: selectedRange)
        
        setNeedsDisplay()
    }
    
    
    // MARK: - Add link attribute
    func addLinkAttribute(mutableAttrString: NSMutableAttributedString) {
        if mutableAttrString.length == 0 {
            return
        }
        
        var range = NSMakeRange(0, 0)
        var attributes = mutableAttrString.attributes(at: 0, effectiveRange: &range)
        attributes[NSAttributedString.Key.font] = font
        attributes[NSAttributedString.Key.foregroundColor] = textColor
        
        mutableAttrString.addAttributes(attributes, range: range)
        
        attributes[NSAttributedString.Key.foregroundColor] = linkTextColor
        
        for range in linkRanges {
            mutableAttrString.setAttributes(attributes, range: range)
        }
    }
    
    // MARK: - Add line break mode
    func addLineBreak(attributedString: NSAttributedString) -> NSMutableAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
        
        if attributedString.length == 0 {
            return mutableAttributedString
        }
        
        var range = NSMakeRange(0, 0)
        var attributes = attributedString.attributes(at: 0, effectiveRange: &range)
        
        let paragraphStyle = attributes[NSAttributedString.Key.paragraphStyle] as? NSMutableParagraphStyle
        if paragraphStyle == nil {
            // iOS 8.0 can not get the paragraphStyle directly
            let style = NSMutableParagraphStyle()
            style.lineBreakMode = NSLineBreakMode.byWordWrapping
            
            attributes[NSAttributedString.Key.paragraphStyle] = style
            
            mutableAttributedString.setAttributes(attributes, range: range)
        } else {
            paragraphStyle?.lineBreakMode = NSLineBreakMode.byWordWrapping
        }
        
        return mutableAttributedString
    }
}


// MARK: - 正则表达式相关
private extension BWLabel {
    
    /// 匹配方案数组 (URL / #xxx# / @xxx)
    var patterns: [String] {
        return ["[a-zA-Z]*://[a-zA-Z0-9/\\.]*", "#.*?#", "@[\\u4e00-\\u9fa5a-zA-Z0-9_-]*"]
    }
    
    /// 匹配处理,以获取匹配结果
    ///
    /// - Parameter attributedString: 属性字符串
    func matchLinkRange(attributedString: NSAttributedString) {
        linkRanges.removeAll()
        
        let range = NSMakeRange(0, attributedString.length)
        
        for pattern in patterns {
            // 1. 创建正则表达式
            let regEx = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators])
            // 2. 进行匹配
            let results = regEx?.matches(in: attributedString.string, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: range)
            // 3. 遍历results,获取匹配结果
            for result in results ?? [] {
                // 匹配结果
                let r = result.range(at: 0)
                // 添加 range
                linkRanges.append(r)
            }
        }
    }
}
