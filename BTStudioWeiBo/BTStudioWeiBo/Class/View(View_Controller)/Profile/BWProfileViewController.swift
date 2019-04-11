//
//  BWProfileViewController.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/3/30.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

class BWProfileViewController: BWBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        BWNetworkManager.shared.userAccount.access_token = nil
    }
    
    
    // MARK: - 监听方法
    @objc func showNext() {
        let vc = BWProfileViewController()
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


extension BWProfileViewController {
    
    override func setupTableView() {
        super.setupTableView()
        
        // 设置右侧按钮
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Haha", style: .plain, target: self, action: #selector(showNext))
        navigationItemCustom.rightBarButtonItem = UIBarButtonItem(title: "Haha", target: self, action: #selector(showNext), isBack: false)
    }
}
