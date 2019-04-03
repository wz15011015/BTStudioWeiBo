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

        setupUI()
        
        loadData()
    }
    
    /// 加载数据
    override func loadData() {
        // 模拟延时加载数据
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            for i in 0..<20 {
                if self.isPullUp {
                    self.statusList.append("上拉数据-\(i)")
                } else {
                    self.statusList.insert(i.description, at: 0)
                }
            }
            
            // 恢复上拉刷新标记
            self.isPullUp = false
            
            // 刷新表格
            self.tableView?.reloadData()
            
            // 结束刷新动画
            self.refreshControl?.endRefreshing()
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
    }
}
