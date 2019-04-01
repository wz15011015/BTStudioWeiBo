//
//  BWBaseViewController.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/3/30.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

class BWBaseViewController: UIViewController {
    
    /// 自定义导航栏
    lazy var navigationBarCustom = BWNavigationBar(frame: CGRect(x: 0, y: 0, width: BW_Width, height: NavBarHeight))
    
    /// 自定义导航栏Item, 以后设置导航栏内容时,统一使用'navigationItemCustom'
    lazy var navigationItemCustom = UINavigationItem()
    
    /// 表格视图 - 如果用户未登录,就不创建
    var tableView: UITableView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    /// 重写UIViewController title 的 didSet 方法
    override var title: String? {
        didSet {
            navigationItemCustom.title = title
        }
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

// MARK: - 设置界面
extension BWBaseViewController {
    
    /// 设置UI
    @objc func setupUI() {
        view.backgroundColor = UIColor.cz_random()
        
        setupNavigationBar()
        
        setupTableView()
    }
    
    /// 设置自定义导航栏
    private func setupNavigationBar() {
        // 自定义导航栏的设置
        // 1. 将item设置给自定义导航栏
        navigationBarCustom.items = [navigationItemCustom]
        
        // 2. 设置自定义导航栏的渲染颜色
        navigationBarCustom.barTintColor = UIColor.cz_color(withHex: 0xF6F6F6)
        
        // 3. 设置自定义导航栏左右按钮的字体颜色
//        navigationBarCustom.tintColor = UIColor.darkGray
        
        // 4. 设置自定义导航栏标题颜色
        navigationBarCustom.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        
        // 添加自定义导航栏
        view.addSubview(navigationBarCustom)
    }
    
    /// 设置表格视图
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        view.insertSubview(tableView!, belowSubview: navigationBarCustom)
    }
}
