//
//  BWNewFeatureView.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/12.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/// 新特性视图
class BWNewFeatureView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var enterButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        // 添加图片
        let count = 4
        let rect = UIScreen.main.bounds
        for i in 0..<count {
            let imageName = "new_feature_\(i + 1)"
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            scrollView.addSubview(imageView)
        }
        
        // 设置scrollView的属性
        scrollView.contentSize = CGSize(width: CGFloat(count + 1) * rect.width, height: rect.height)
        scrollView.delegate = self
        
        // 隐藏按钮
        enterButton.isHidden = true
    }
    
    /// 类方法 从xib加载view
    ///
    /// - Returns: 视图
    class func newFeatureView() -> BWNewFeatureView {
        let nib = UINib(nibName: "BWNewFeatureView", bundle: nil)
        
        let v = nib.instantiate(withOwner: self, options: nil)[0] as! BWNewFeatureView
      
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    
    /// 进入微博
    ///
    /// - Parameter sender: 按钮
    @IBAction func enterEvent(sender: UIButton) {
        removeFromSuperview()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

// MARK: - UIScrollView代理
extension BWNewFeatureView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 1. 滚动到最后一屏时,需要删除视图
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        if page == scrollView.subviews.count {
            removeFromSuperview()
        }
        
        // 2. 倒数第二页显示进入按钮
        if page == scrollView.subviews.count - 1 {
            enterButton.isHidden = false
        } else {
            enterButton.isHidden = true
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 一旦滚动就隐藏按钮
        enterButton.isHidden = true
        
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        // 设置分页控件的页数
        pageControl.currentPage = page
        
        // 分页控件的隐藏
        if page == scrollView.subviews.count {
            pageControl.isHidden = true
        } else {
            pageControl.isHidden = false
        }
    }
}
