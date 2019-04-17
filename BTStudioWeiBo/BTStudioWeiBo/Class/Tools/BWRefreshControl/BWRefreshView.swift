//
//  BWRefreshView.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/17.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/// 刷新视图 - 负责刷新相关的UI显示和动画
class BWRefreshView: UIView {
    /**
     iOS 系统中UIView封装的旋转动画:
     - 默认是顺时针旋转的;
     - 就近原则;
     - 要想实现同方向旋转,需要调整一个非常小的数字,使其不到180° (不到180°更近点)
     */
    
    /// 刷新状态
    var refreshState: BWRefreshState = .normal {
        didSet {
            switch refreshState {
            case .normal:
                tipLabel?.text = "继续使劲拉"
                // 显示提示图标,隐藏菊花指示器
                tipImageView?.isHidden = false
                indicator?.stopAnimating()
                UIView.animate(withDuration: 0.25) {
                    self.tipImageView?.transform = CGAffineTransform.identity
                }
                
            case .pulling:
                tipLabel?.text = "放手就刷新"
                UIView.animate(withDuration: 0.25) {
                    self.tipImageView?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi + 0.01))
                }
                
            case .willRefresh:
                tipLabel?.text = "正在刷新中..."
                // 隐藏提示图标,显示菊花指示器
                tipImageView?.isHidden = true
                indicator?.startAnimating()
            }
        }
    }

    /// 提示图标
    @IBOutlet weak var tipImageView: UIImageView?
    
    /// 提示标签
    @IBOutlet weak var tipLabel: UILabel?
    
    /// 指示器
    @IBOutlet weak var indicator: UIActivityIndicatorView?
    
    
    class func refreshView() -> BWRefreshView {
        let nib = UINib(nibName: "BWRefreshView", bundle: nil)
        
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! BWRefreshView
        
        return view
    }
    
    class func humanRefreshView() -> BWRefreshView {
        let nib = UINib(nibName: "BWHumanRefreshView", bundle: nil)
        
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! BWRefreshView
        
        return view
    }
    
    class func meituanRefreshView() -> BWRefreshView {
        let nib = UINib(nibName: "BWMTRefreshView", bundle: nil)
        
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! BWRefreshView
        
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
