//
//  BWEmoticonCell.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/25.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/**
 * - 每一个Cell和CollectionView的frame同样大小;
 * - 每一个Cell中采用九宫格布局21个视图 (20个表情 + 一个删除键);
 * - 最后一个位置为删除按钮;
 */


/// 表情Cell代理
@objc protocol BWEmoticonCellDelegate: NSObjectProtocol {
    
    /// 表情 Cell 选中表情模型
    ///
    /// - Parameters:
    ///   - cell: 表情Cell
    ///   - emoticon: 表情模型 / nil表示点击了删除
    @objc optional func emoticonCellDidSelectedEmoticon(cell: BWEmoticonCell, emoticon: BWEmoticon?)
}


/// 表情键盘的表情页面Cell
class BWEmoticonCell: UICollectionViewCell {
    
    /// 代理
    weak var delegate: BWEmoticonCellDelegate?
    
    /// 当前页面的表情模型数组(最多20个)
    var emoticons: [BWEmoticon]? {
        didSet {
            // 1. 先隐藏所有按钮
            for view in contentView.subviews {
                view.isHidden = true
            }
            
            // 2. 遍历表情模型数组,设置按钮图片并显示
            for (i, emoticon) in (emoticons ?? []).enumerated() {
                // 取出按钮
                let button = contentView.subviews[i] as! UIButton
                
                // 设置图片 - 如果图片为nil,设置后会清空图片,避免复用
                button.setImage(emoticon.image, for: .normal)
                
                // 设置emoji字符串 - 如果emoji字符串为nil,设置后会清空标题,避免复用
                button.setTitle(emoticon.emoji, for: .normal)
                
                // 显示按钮
                button.isHidden = false
            }
            
            // 3. 取出末尾的删除按钮
            let removeButton = contentView.subviews.last as! UIButton
            let image = UIImage(named: "compose_emotion_delete", in: BWEmoticonManager.shared.bundle, compatibleWith: nil)
            let imageHighlight = UIImage(named: "compose_emotion_delete_highlight", in: BWEmoticonManager.shared.bundle, compatibleWith: nil)
            removeButton.setImage(image, for: .normal)
            removeButton.setImage(imageHighlight, for: .highlighted)
            removeButton.isHidden = false
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: 监听方法
    
    /// 点击表情事件
    ///
    /// - Parameter sender: 表情按钮
    @objc private func selectedEmoticonButton(sender: UIButton) {
        guard let emoticons = emoticons else { return }
        
        // 1. 取出tag 0~20, 20对应的为删除按钮
        let tag = sender.tag
        
        // 2. 根据tag判断是否为删除按钮,并获取表情模型
        var emoticon: BWEmoticon?
        if tag < emoticons.count {
            emoticon = emoticons[tag]
        }
        
        // 3. emoticon要么是选中的按钮,要么为nil,为nil时是删除按钮
        // 通知代理调用协议方法
        delegate?.emoticonCellDidSelectedEmoticon?(cell: self, emoticon: emoticon)
    }
    

//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        setupUI()
//    }

}


// MARK: - 设置界面
private extension BWEmoticonCell {
    /**
     - 从xib加载, bounds 是xib中定义的大小,不是布局属性中设置的itemSize的大小
     - 使用纯代码加载, bounds 就是布局属性中设置的itemSize的大小
     */
    
    func setupUI() {
        // 创建21个按钮
        let rowCount = 3
        let columnCount = 7
        
        let leftMargin: CGFloat = 8
        let bottomMargin: CGFloat = 16
        
        let w = (bounds.width - 2 * leftMargin) / CGFloat(columnCount)
        let h = (bounds.height - bottomMargin) / CGFloat(rowCount)
        
        for i in 0..<21 {
            let row = i / columnCount
            let column = i % columnCount
            
            let button = UIButton()
            button.frame = CGRect(x: leftMargin + (CGFloat(column) * w), y: CGFloat(row) * h, width: w, height: h)
            // 设置按钮字体大小
            button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            // 设置tag
            button.tag = i
            // 添加监听事件
            button.addTarget(self, action: #selector(selectedEmoticonButton(sender:)), for: .touchUpInside)
            
            contentView.addSubview(button)
        }
    }
}
