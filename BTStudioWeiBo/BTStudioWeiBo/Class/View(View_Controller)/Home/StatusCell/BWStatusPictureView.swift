//
//  BWStatusPictureView.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/15.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/// 微博配图视图
class BWStatusPictureView: UIView {
    
    /// 配图地址数组
    var urls: [BWStatusPicture]? {
        didSet {
            // 1. 隐藏所有imageView
            for view in subviews {
                view.isHidden = true
            }
            // 2. 根据数据设置图片
//            for (index, url) in urls?.enumerated() ?? [].enumerated() {
            
            var index = 0
            for url in urls ?? [] {
                let imageView = subviews[index] as! UIImageView
                imageView.isHidden = false
                imageView.cz_setImage(urlString: url.thumbnail_pic, placeholderImage: nil)
                
                // 针对4张图片时的处理, 2x2格式排列
                if index == 1 && urls?.count == 4 {
                    index += 2
                } else {
                    index += 1
                }
            }
        }
    }
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        clipsToBounds = true // 超出边界的内容不显示
        
        setupUI()
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
extension BWStatusPictureView {
    // 1. Cell中所有的控件都是提前准备好
    // 2. 设置的时候,根据数据决定是否显示
    // 3. 不要动态创建控件
    
    private func setupUI() {
        // 设置背景颜色
        backgroundColor = superview?.backgroundColor
        
        let count = 9
        let rect = CGRect(x: 0, y: WBStatusPictureViewOutterMargin, width: WBStatusPictureItemWidth, height: WBStatusPictureItemWidth)
        
        for i in 0..<count {
            let imageView = UIImageView()
            
            let row = Double(i / 3)
            let column = Double(i % 3)
            let offsetX = CGFloat(column * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMargin))
            let offsetY = CGFloat(row * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMargin))
            imageView.frame = rect.offsetBy(dx: offsetX, dy: offsetY)
            
            addSubview(imageView)
        }
    }
}