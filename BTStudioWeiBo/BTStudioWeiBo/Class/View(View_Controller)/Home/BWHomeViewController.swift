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
    
    private lazy var listViewModel = BWStatusListViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    /// 加载数据
    override func loadData() {
        // 用 网络工具 加载微博数据
//        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
//        let params = ["access_token": "2.00UfZikCTQtzcE9e3084d975yflGtC"]
//        BWNetworkManager.shared.get(urlString, parameters: params, progress: { (progress) in
//            print("请求进度: \(progress)")
//        }, success: { (_, json) in
//            print("json: \(json.debugDescription)")
//        }) { (_, error) in
//            print("网络请求失败, error: \(error)")
//        }
        
//        BWNetworkManager.shared.request(method: .GET, URLString: urlString, parameters: params) { (json, isSuccess) in
//            print("isSuccess: \(isSuccess)")
//            print("json: \(json.debugDescription)")
//        }
        
        
        // 模拟延时加载数据
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            for i in 0..<20 {
//                if self.isPullUp {
//                    self.statusList.append("上拉数据-\(i)")
//                } else {
//                    self.statusList.insert(i.description, at: 0)
//                }
//            }
//
//            // 恢复上拉刷新标记
//            self.isPullUp = false
//
//            // 刷新表格
//            self.tableView?.reloadData()
//
//            // 结束刷新动画
//            self.refreshControl?.endRefreshing()
//        }
        
        print("最后一条微博: \(listViewModel.statusList.last?.text ?? "")")
        // 加载数据
        listViewModel.loadStatus(pullUp: isPullUp) { (isSuccess, shouldRefresh) in
            // 恢复上拉刷新标记
            self.isPullUp = false
            
            // 刷新表格
            self.tableView?.reloadData()
            
            // 结束刷新动画
            shouldRefresh ? self.refreshControl?.endRefreshing() : ()
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
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let status = listViewModel.statusList[indexPath.row]
        cell.textLabel?.text = status.text
        
        return cell
    }
}

// MARK: - 设置界面
extension BWHomeViewController {
    
    override func setupTableView() {
        super.setupTableView()
        
        // 设置导航栏按钮
        navigationItemCustom.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
        
        // 注册cell
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
}
