//
//  BWBaseViewController.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/3/30.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/**
 Swift中,利用 extension 可以把'函数'按照功能分类管理,便于阅读和维护.
 需要注意:
     - extension 中不能有属性;
     - extension 中不能重写父类方法, 重写父类方法是子类的职责,扩展是对类的扩展.
 */

/// 基类控制器
class BWBaseViewController: UIViewController {
    
    /// 用户是否登录标记
//    var userLogon = true
    
    /// 访客视图信息字典
    var visitorInfoDictionary: [String: String]?
    
    /// 自定义导航栏
    lazy var navigationBarCustom = BWNavigationBar(frame: CGRect(x: 0, y: 0, width: BW_Width, height: NavBarHeight))
    
    /// 自定义导航栏Item, 以后设置导航栏内容时,统一使用'navigationItemCustom'
    lazy var navigationItemCustom = UINavigationItem()
    
    /// 表格视图 - 如果用户未登录,就不创建
    var tableView: UITableView?
    
    /// 刷新控件
    var refreshControl: BWRefreshControl?
    
    /// 是否上拉刷新
    var isPullUp: Bool = false

    
    deinit {
        // 注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            // iOS 11.0之后使用UIScrollView的 contentInsetAdjustmentBehavior 代替
        } else {
            // 取消自动缩进 - 如果隐藏了导航栏,会缩进20个点
            automaticallyAdjustsScrollViewInsets = false
        }
        
        setupUI()
        
        BWNetworkManager.shared.userLogon ? loadData() : ()
        
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess(notification:)), name: NSNotification.Name(rawValue: BWUserLoginSuccessNotification), object: nil)
    }
    
    /// 重写UIViewController title 的 didSet 方法
    override var title: String? {
        didSet {
            navigationItemCustom.title = title
        }
    }
    
    /// 加载数据 - 具体的实现由子类负责
    @objc func loadData() {
        // 如果子类不实现该方法,则需要结束刷新控件动画
        refreshControl?.endRefreshing()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: - 访客视图监听方法
extension BWBaseViewController {
    @objc private func login() {
        // 发送登录通知
        NotificationCenter.default.post(name: NSNotification.Name(BWUserShouldLoginNotification), object: nil)
    }
    
    @objc private func register() {
        // 发送注册通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: BWUserShouldRegisterNotification), object: nil)
    }
    
    /// 登录成功
    @objc private func loginSuccess(notification: Notification) {
        // 更新界面
        navigationItemCustom.leftBarButtonItem = nil
        navigationItemCustom.rightBarButtonItem = nil
        
        /**
         在访问view的getter方法时,如果view为nil,则会调用: loadView -> viewDidLoad
         */
        view = nil
        
        // 注销通知 (因为重新执行了viewDidLoad,避免通知被重复注册)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: BWUserLoginSuccessNotification), object: nil)
    }
}


// MARK: - 设置界面
extension BWBaseViewController {
    
    /// 设置UI
    @objc private func setupUI() {
        view.backgroundColor = UIColor.white
        
        setupNavigationBar()
        
        BWNetworkManager.shared.userLogon ? setupTableView() : setupVisitorView()
    }
    
    /// 设置自定义导航栏
    private func setupNavigationBar() {
        // 自定义导航栏的设置
        // 1. 将item设置给自定义导航栏
        navigationBarCustom.items = [navigationItemCustom]
        
        // 2. 设置自定义导航栏的背景渲染颜色
        navigationBarCustom.barTintColor = UIColor.cz_color(withHex: 0xF6F6F6)
        
        // 3. 设置自定义导航栏左右按钮的字体颜色
        navigationBarCustom.tintColor = UIColor.orange
        
        // 4. 设置自定义导航栏标题颜色
        navigationBarCustom.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        
        // 添加自定义导航栏
        view.addSubview(navigationBarCustom)
    }
    
    /// 设置表格视图
    ///
    /// 子类重写此方法,因为子类不需要关心用户登录之后的逻辑
    @objc func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        // 设置数据源代理
        tableView?.dataSource = self
        tableView?.delegate = self
        
        view.insertSubview(tableView!, belowSubview: navigationBarCustom)
        
        if #available(iOS 11.0, *) {
            // 默认为automatic,设置为 automatic 相当于 automaticallyAdjustsScrollViewInsets = YES
            tableView?.contentInsetAdjustmentBehavior = .automatic
            
            // 若使用了系统导航栏,则设置为automatic后,tableView高度会自动适应除去导航栏和工具栏的高度
            // 本项目中隐藏了系统导航栏,使用了自定义导航栏,因此需要再调整一下tableView的contentInset
            // 44 为导航栏中导航内容_UINavigationBarContentView的高度
            tableView?.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        } else {
            // 若不取消自动缩进,则需要设置contentInset来调整
            //            tableView?.contentInset = UIEdgeInsets(top: CGFloat(NavBarHeight), left: 0, bottom: CGFloat(TabBarHeight), right: 0)
        }
        
        // 修改竖直指示器的缩进
        tableView?.scrollIndicatorInsets = tableView!.contentInset
        
        // 设置刷新控件
        // 1. 实例化控件
        refreshControl = BWRefreshControl()
        // 2. 添加到视图
        tableView?.addSubview(refreshControl!)
        // 3. 添加监听方法
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    /// 设置访客视图
    private func setupVisitorView() {
        let visitorView = BWVisitorView(frame: view.bounds)
        visitorView.visitorInfo = visitorInfoDictionary
        view.insertSubview(visitorView, belowSubview: navigationBarCustom)
        
        // 添加访客视图按钮的监听事件
        visitorView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        visitorView.registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        
        // 设置导航栏按钮
        navigationItemCustom.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(register))
        navigationItemCustom.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(login))
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension BWBaseViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    // 基类只是准备方法,子类负责具体实现
    // 子类的数据源方法不需要 super
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 此处代码只是保证没有语法错误!
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 在显示最后一行的时候,进行上拉刷新
        // 1. 判断是否为最后一行
        let row = indexPath.row
        let section = tableView.numberOfSections - 1
        if row < 0 || section < 0 {
            return
        }
        
        let count = tableView.numberOfRows(inSection: section)
        // 如果是最后一行,同时没有开始上拉刷新
        if row == count - 1 && !isPullUp {
            // 设置上拉刷新标记
            isPullUp = true
            
            // 开始刷新
            loadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    
    func avatarImage(image: UIImage, size: CGSize, backColor: UIColor?) -> UIImage? {
        /**
         * 针对图像混合模式和拉伸的优化
         * - 针对混合模式的优化: opaque为true,即为不透明,不透明可以减少计算
         * - 针对图像拉伸的优化: 重新绘制指定大小的图像
         */
        let rect = CGRect(origin: CGPoint(), size: size)
        
        // 1. 图像的上下文 (内存中开辟一块空间,和屏幕无关!)
        /**
         * size: 绘图的尺寸
         * opaque(不透明度): true 不透明 / false 透明
         * scale(屏幕分辨率): 指定为0时,则默认使用当前设备的屏幕分辨率
         */
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        
        // 1.1 裁切前社长背景填充颜色
        backColor?.setFill()
        UIRectFill(rect)
        // 1.2 实例化一个圆形路径
        let path = UIBezierPath(ovalIn: rect)
        // 1.3 进行路径裁切 - 后续的绘图都会在圆形路径内进行
        path.addClip()
        
        // 2. 绘图 (就是在指定区域内拉伸)
        image.draw(in: rect)
        
        // 2.1 绘制内切的圆形边框
        UIColor.darkGray.setStroke()
        path.lineWidth = 2 // 边框宽度
        path.stroke()
        
        // 3. 取得结果
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        // 4. 关闭上下文
        UIGraphicsEndImageContext()
        
        // 5. 返回结果
        return result
    }
}
