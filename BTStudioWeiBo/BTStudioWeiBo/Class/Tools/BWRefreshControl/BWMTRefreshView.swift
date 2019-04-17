//
//  BWMTRefreshView.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/17.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

class BWMTRefreshView: BWRefreshView {
    
    @IBOutlet weak var buildingIconImageView: UIImageView!
    @IBOutlet weak var kangarooImageView: UIImageView!
    @IBOutlet weak var earthImageView: UIImageView!
    
    
    override func awakeFromNib() {
        // 1. 房子动画 (序列帧)
        guard let building1Image = UIImage(named: "icon_building_loading_1"),
            let building2Image = UIImage(named: "icon_building_loading_2") else {
                return
        }
        buildingIconImageView.image = UIImage.animatedImage(with: [building1Image, building2Image], duration: 0.5)
        
        // 2. 袋鼠动画 (序列帧)
        guard let kangarooImage1 = UIImage(named: "icon_small_kangaroo_loading_1"),
            let kangarooImage2 = UIImage(named: "icon_small_kangaroo_loading_2") else {
                return
        }
        kangarooImageView.image = UIImage.animatedImage(with: [kangarooImage1, kangarooImage2], duration: 0.5)
        
        // 3. 地球旋转动画
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = -2 * Double.pi
        animation.repeatCount = HUGE
        animation.duration = 1.5
        animation.isRemovedOnCompletion = false
        earthImageView.layer.add(animation, forKey: nil)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
