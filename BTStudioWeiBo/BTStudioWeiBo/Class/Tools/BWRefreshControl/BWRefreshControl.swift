//
//  BWRefreshControl.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/16.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/// 刷新状态切换的临界点
private let BWRefreshOffset: CGFloat = 100

/// 刷新控件的状态
///
/// - normal: 普通状态,下拉开始刷新...
/// - pulling: 超过临界点,如果放手,开始刷新
/// - willRefresh: 超过临界点,并且放手,刷新数据
enum BWRefreshState {
    case normal
    case pulling
    case willRefresh
}


/// 自定义刷新控件 - 负责刷新相关的逻辑处理
class BWRefreshControl: UIControl {
    
    // MARK: - 属性
    /// 滚动视图的父视图
    ///
    /// 下拉刷新控件应该适用于UITableView / UICollectionView
    private weak var scrollView: UIScrollView?
    
    private lazy var refreshView = BWRefreshView.meituanRefreshView()
    
    
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
        
        // KVO监听父视图的contentOffset
        // 观察者模式在不需要的时候,都需要释放掉
        // - 通知中心: 如果不释放,什么也不会发生,但是会有内存泄漏,会有多次注册的可能!
        // - KVO: 如果不释放,会崩溃!
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    /// 本视图从父视图上移除
    ///
    /// 提示: 所有的第三方下拉刷新框架都是监听父视图的 contentOffset
    /// 所有框架的KVO监听实现思路都是这个!
    override func removeFromSuperview() {
        // 此时,superView还存在,为UITableView
        
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        
        super.removeFromSuperview()
        
        // 此时,superView已经不存在了
    }
    
    
    /// 所有KVO方法会统一调用此方法
    ///
    /// - Parameters:
    ///   - keyPath: keyPath
    ///   - object: object
    ///   - change: change
    ///   - context: context
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let sv = scrollView else {
            return
        }
        var height = -(sv.contentInset.top + sv.contentOffset.y)
        
        // 本项目中隐藏了系统导航栏,使用了自定义导航栏
        // 44 为导航栏中导航内容_UINavigationBarContentView的高度
        if #available(iOS 11.0, *) {
            height -= CGFloat(44)
        }
        
        // 如果向上滚动,则直接返回
        if height < 0 {
            return
        }
        
        // 根据滚动视图的偏移量调整刷新控件的frame
        self.frame = CGRect(x: 0, y: -height, width: sv.bounds.width, height: height)
        
        // 传递父视图高度
        refreshView.parentViewHeight = height
        
        // 是否在拖拽
        if sv.isDragging {
            if height > BWRefreshOffset && refreshView.refreshState == .normal {
                print("可以松开了...")
                refreshView.refreshState = .pulling
            } else if height <= BWRefreshOffset && refreshView.refreshState == .pulling {
                print("继续下拉....")
                refreshView.refreshState = .normal
            }
        } else { // 放手
            // 判断是否超过临界点
            if refreshView.refreshState == .pulling {
                // 刷新结束之后,将状态修改为normal,才能够继续响应刷新
                
                beginRefreshing()
                
                // 发送刷新数据事件
                sendActions(for: .valueChanged)
            }
        }
    }
    
    
    /// 开始刷新
    func beginRefreshing() {
        // 判断父视图
        guard let sv = scrollView else {
            return
        }
        
        // 判断是否正在刷新,如果正在刷新,则直接返回
        if refreshView.refreshState == .willRefresh {
            return
        }
        
        // 设置刷新视图的状态
        refreshView.refreshState = .willRefresh
        
        // 调整表格视图的contentInset,以让整个刷新视图显示出来
        var inset = sv.contentInset
        inset.top += BWRefreshOffset
        sv.contentInset = inset
        
        // 设置刷新视图的父视图高度
        refreshView.parentViewHeight = BWRefreshOffset
    }
    
    /// 结束刷新
    func endRefreshing() {
        guard let sv = scrollView else {
            return
        }
        
        // 判断是否正在刷新,如果未在刷新,则直接返回
        if refreshView.refreshState != .willRefresh {
            return
        }
        
        // 恢复刷新视图的状态
        refreshView.refreshState = .normal
        
        // 恢复表格视图的contentInset
        var inset = sv.contentInset
        inset.top -= BWRefreshOffset
        sv.contentInset = inset
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
        backgroundColor = superview?.backgroundColor
        
        // 超出边界不显示
//        clipsToBounds = true
        
        addSubview(refreshView)
        
        // 自动布局 - 设置xib控件的自动布局,需要指定宽高的约束
        /// 提示: 对于iOS程序员,一定要会原生的写法,因为:如果自己开发框架,不能用任何的自动布局框架
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        
        // 宽高的约束
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: refreshView.bounds.width))
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: refreshView.bounds.height))
    }
}
