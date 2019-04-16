//
//  BWRefreshControl.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/16.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/// 自定义刷新控件
class BWRefreshControl: UIControl {
    // MARK: - 属性
    /// 滚动视图的父视图
    ///
    /// 下拉刷新控件应该适用于UITableView / UICollectionView
    private weak var scrollView: UIScrollView?
    
    deinit {
        scrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    // MARK: - 构造函数
    init() {
        super.init(frame: CGRect())
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    /**
     willMove(toSuperview newSuperview: )方法的调用:
     - 当添加到父视图时,newSuperview是父视图
     - 当父视图被移除时,newSuperview是nil
     */
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        // 记录父视图
        guard let superView = newSuperview as? UIScrollView else {
            return
        }
        scrollView = superView
        
//        scrollView?.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        
        // KVO监听父视图的contentOffset
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    
    /// 所有KVO方法会统一调用此方法
    ///
    /// - Parameters:
    ///   - keyPath: <#keyPath description#>
    ///   - object: <#object description#>
    ///   - change: <#change description#>
    ///   - context: <#context description#>
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let sv = scrollView else {
            return
        }
        let height = -(sv.contentInset.top + sv.contentOffset.y)
        // 根据滚动视图的偏移量调整刷新控件的frame
        self.frame = CGRect(x: 0, y: -height, width: sv.bounds.width, height: height)
    }
    
    
    /// 开始刷新
    func beginRefreshing() {
        
    }
    
    /// 结束刷新
    func endRefreshing() {
        
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
extension BWRefreshControl {
    
    /// 设置界面
    private func setupUI() {
        backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    }
}
