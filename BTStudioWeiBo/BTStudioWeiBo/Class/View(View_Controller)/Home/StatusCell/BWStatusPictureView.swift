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
    
    var viewModel: BWStatusViewModel? {
        didSet {
            calcViewSize()
            
            // 设置urls
            // 设置配图地址
            // 测试代码
//            if let count = viewModel?.status.pic_urls?.count {
//                if count > 4 {
//                    viewModel?.status.pic_urls?.removeSubrange(4..<count)
//                    urls = viewModel?.status.pic_urls
//                } else {
//                    urls = viewModel?.status.pic_urls
//                }
//            }
            urls = viewModel?.picURLs
        }
    }
    
    /// 配图地址数组
    private var urls: [BWStatusPicture]? {
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
                
                // 判断是否为Gif (根据扩展名判断是否为Gif,若为Gif则显示Gif提示图标;否则,隐藏Gif提示图标)
                imageView.subviews[0].isHidden = ((url.thumbnail_pic ?? "") as NSString).pathExtension.lowercased() != "gif"
            }
        }
    }
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        clipsToBounds = true // 超出边界的内容不显示
        
        setupUI()
    }
    
    /// 根据视图模型中的配图视图大小,调整显示内容
    private func calcViewSize() {
        // 1. 第一张图片宽度的处理
        // 1.1 单图
        if viewModel?.picURLs?.count == 1 {
            let viewSize = viewModel?.pictureViewSize ?? CGSize()
            
            // 获取第一张图片(单图)
            let imageView = subviews[0]
            imageView.frame = CGRect(x: 0.0, y: WBStatusPictureViewOutterMargin, width: Double(viewSize.width), height: Double(viewSize.height) - WBStatusPictureViewOutterMargin)
            
        // 1.2 多图
        } else {
            // 获取第一张图片,恢复其大小为九宫格格式的大小,以保证九宫格布局的正确显示
            let imageView = subviews[0]
            imageView.frame = CGRect(x: 0.0, y: WBStatusPictureViewOutterMargin, width: WBStatusPictureItemWidth, height: WBStatusPictureItemWidth)
        }
        
        
        // 2. 修改配图视图高度的约束值
        heightConstraint.constant = viewModel?.pictureViewSize.height ?? 0
    }
    
    
    // MARK: - 监听方法
    
    /// 点击了图片
    @objc private func tapImageView(gesture: UITapGestureRecognizer) {
        guard let imageView = gesture.view as? UIImageView,
            let picURLs = viewModel?.picURLs else {
            return
        }
        // 选中的索引
        var selectedIndex = imageView.tag
        
        // 针对四张图进行处理
        if picURLs.count == 4 && selectedIndex > 1 {
            selectedIndex -= 1
        }
        
        // 图片URL字符串数组
        let urls = (picURLs as NSArray).value(forKey: "large_pic") as! [String]
        
        // 图片视图数组
        var imageViews: [UIImageView] = []
        for iv in subviews as! [UIImageView] {
            if !iv.isHidden {
                imageViews.append(iv)
            }
        }
        
        // 发送浏览图片的通知
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: BWStatusCellBrowserPhotoNotification), object: nil, userInfo:
            [BWStatusCellBrowserPhotoSelectedIndexKey: selectedIndex,
             BWStatusCellBrowserPhotoURLsKey: urls,
             BWStatusCellBrowserPhotoImageViewsKey: imageViews
            ])
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
    // [⚠️- 谨记知识点 -⚠️]
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
            
            // 设置tag
            imageView.tag = i
            
            addSubview(imageView)
            
            // 让imageView能够接收用户交互
            imageView.isUserInteractionEnabled = true
            
            // 添加手势
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapImageView(gesture:)))
            imageView.addGestureRecognizer(tapGR)
            
            // 设置imageView的Gif提示图标
            addGifTip(imageView: imageView)
        }
    }
    
    /// 向图片视图添加Gif提示图标
    ///
    /// - Parameter imageView: 图片视图
    private func addGifTip(imageView: UIImageView) {
        let gifTipImageView = UIImageView(image: UIImage(named: "timeline_image_gif"))
        imageView.addSubview(gifTipImageView)
        
        // 自动布局
        gifTipImageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.addConstraint(NSLayoutConstraint(item: gifTipImageView, attribute: .right, relatedBy: .equal, toItem: imageView, attribute: .right, multiplier: 1.0, constant: 0))
        imageView.addConstraint(NSLayoutConstraint(item: gifTipImageView, attribute: .bottom, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1.0, constant: 0))
    }
}
