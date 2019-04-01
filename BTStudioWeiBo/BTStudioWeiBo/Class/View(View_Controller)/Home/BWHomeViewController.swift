//
//  BWHomeViewController.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/3/30.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

class BWHomeViewController: BWBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
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

extension BWHomeViewController {
    
    /// 重写父类的方法
    override func setupUI() {
        super.setupUI()
        
        // 设置导航栏按钮
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
        navigationItemCustom.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
    }
}
