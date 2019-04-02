//
//  BWHomeViewController.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/3/30.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/// 定义全局常量,尽量使用 private 修饰,否则到处都可以访问
private let cellID = "CellIdentifier"


class BWHomeViewController: BWBaseViewController {
    
    /// 微博数据数组
    private lazy var statusList: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            // iOS 11.0之后使用UIScrollView的 contentInsetAdjustmentBehavior 代替
        } else {
            // 取消自动缩进 - 如果隐藏了导航栏,会缩进20个点
            automaticallyAdjustsScrollViewInsets = false
        }

        setupUI()
        
        loadData()
    }
    
    /// 加载数据
    override func loadData() {
        for i in 0..<20 {
            statusList.insert(i.description, at: 0)
        }
    }
    
    /// 显示好友
    @objc func showFriends() {
        let vc = BWProfileViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
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

// MARK: - 表格数据源方法
extension BWHomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let status = statusList[indexPath.row]
        cell.textLabel?.text = status
        
        return cell
    }
}

// MARK: - 设置界面
extension BWHomeViewController {
    
    /// 重写父类的方法
    override func setupUI() {
        super.setupUI()
        
        // 设置导航栏按钮
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
        navigationItemCustom.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
        
        // 注册cell
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
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
    }
}
