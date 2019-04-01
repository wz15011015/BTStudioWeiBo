//
//  BWNavigationController.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/3/30.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

class BWNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 隐藏系统的NavigationBar,为了使用自定义的导航栏
        navigationBar.isHidden = true
    }
    
    /// 重写Push方法,所有push动作都会调用此方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            // 隐藏tabBar
            viewController.hidesBottomBarWhenPushed = true
            
            // 判断是否为基类控制器
            if let vc = viewController as? BWBaseViewController {
                var backTitle = "返回"
                // 第二级页面的返回按钮显示根控制器的标题; 其他更深层级,返回按钮显示为"返回"
                if viewControllers.count == 1 {
                    backTitle = viewControllers.first?.title ?? "返回"
                }
                
                // 取出自定义导航栏内容
                vc.navigationItemCustom.leftBarButtonItem = UIBarButtonItem(title: backTitle, target: self, action: #selector(popToParent), isBack: true)
            }
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        return super.popViewController(animated: animated)
    }
    
    @objc private func popToParent() {
        _ = popViewController(animated: true)
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

extension BWNavigationController {
 
}
