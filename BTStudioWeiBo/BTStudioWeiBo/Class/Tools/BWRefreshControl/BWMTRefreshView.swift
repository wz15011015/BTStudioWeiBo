//
//  BWMTRefreshView.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/17.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/// 美团外卖 下拉刷新控件
class BWMTRefreshView: BWRefreshView {
    
    /// 建筑背景图片
    @IBOutlet weak var buildingImageView: UIImageView!
    
    /// 袋鼠图片
    @IBOutlet weak var kangarooImageView: UIImageView!
    
    /// 地球图片
    @IBOutlet weak var earthImageView: UIImageView!
    
    /// 父视图高度
    override var parentViewHeight: CGFloat {
        didSet {
//            print("父视图高度: \(parentViewHeight)")
            if parentViewHeight < 23 {
                return
            }
            // 23 -> 126  (比例: 0.2 -> 1.0)
            var scale: CGFloat = 1.0
            if parentViewHeight > 126 {
                scale = 1
            } else {
                scale = 1.0 - (126 - parentViewHeight) / (126 - 23)
            }
            kangarooImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    
    override func awakeFromNib() {
        // 1. 建筑动画 (序列帧)
        if let building1Image = UIImage(named: "icon_building_loading_1"),
            let building2Image = UIImage(named: "icon_building_loading_2") {
            buildingImageView.image = UIImage.animatedImage(with: [building1Image, building2Image], duration: 0.5)
        }
        
        // 2. 袋鼠动画 (序列帧+缩放)
        if let kangarooImage1 = UIImage(named: "icon_small_kangaroo_loading_1"),
            let kangarooImage2 = UIImage(named: "icon_small_kangaroo_loading_2") {
            kangarooImageView.image = UIImage.animatedImage(with: [kangarooImage1, kangarooImage2], duration: 0.4)
        }
        
        // 设置锚点
        kangarooImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        // 设置frame
        let x = self.bounds.width * 0.5
        let y = self.bounds.height - 36
        kangarooImageView.center = CGPoint(x: x, y: y)
        
        kangarooImageView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        
        // 3. 地球旋转动画
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = -2 * Double.pi
        animation.repeatCount = HUGE
        animation.duration = 1.5
        animation.isRemovedOnCompletion = false
        earthImageView.layer.add(animation, forKey: nil)
    }
    
    override class func refreshView() -> BWMTRefreshView {
        let nib = UINib(nibName: "BWMTRefreshView", bundle: nil)
        
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! BWMTRefreshView
        
        return view
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
