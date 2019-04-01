//
//  BWMainViewController.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/3/30.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/// 主控制器
class BWMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupChildControllers()
        setupComposeButton()
    }
    
    /// 使用代码控制设备的方向
    ///
    /// 设置支持的方向之后,当前的控制器及其子控制器都会遵守这个方向!
    ///
    /// 如果是视频播放,通常通过 modal 推出控制器!
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    // MARK: - 监听方法
    /**
     private 保证方法私有,仅在当前对象里能被访问
     @objc 允许方法在'运行时'通过OC的消息机制被调用
     */
    @objc private func composeStatus() {
        print("发微博...")
    }
    
    
    // MARK: - 私有控件
    private lazy var composeButton: UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


// extension类似于OC中的分类,它还可以用来切分代码块
// 可以把相近功能的函数放在一个extension中,便于代码的维护
// 注意: 和OC的分类一样,extension中不能定义属性
// MARK: - 设置界面
extension BWMainViewController {
    /// 添加撰写按钮
    private func setupComposeButton() {
        tabBar.addSubview(composeButton)
        
        // 计算按钮的宽度
        let count = viewControllers?.count ?? 0
        // - 1 是为了把按钮的宽度变大一点,以消除按钮之间容错点的影响
        let w = tabBar.frame.width / CGFloat(count) - 1
        
        // 缩进 (OC中为CGRectInset, 正数表示向内缩进,负数表示向外扩展)
        composeButton.frame = tabBar.bounds.insetBy(dx: 2 * w, dy: 0)
        
        // 添加监听方法
        composeButton.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
    }
    
    /// 设置所有子控件器
    private func setupChildControllers() {
        let array: [[String: String]] = [
            ["clsName": "BWHomeViewController", "title": "首页", "imageName": "home"],
            ["clsName": "BWMessageViewController", "title": "消息", "imageName": "message_center"],
            ["clsName": "UIViewController"], // 占位tabBar
            ["clsName": "BWDiscoveryViewController", "title": "发现", "imageName": "discover"],
            ["clsName": "BWProfileViewController", "title": "我的", "imageName": "profile"]
        ]
        
        var controllers: [UIViewController] = []
        for dict in array {
            controllers.append(controller(dict: dict))
        }
        
        viewControllers = controllers
    }
    
    /// 使用字典创建一个子控制器
    ///
    /// - Parameter dict: 信息字典
    /// - Returns: 子控制器
    private func controller(dict: [String: String]) -> UIViewController {
        // 1. 取得字典内容
        guard let className = dict["clsName"],
            let title = dict["title"],
            let imageName = dict["imageName"],
            // 将className转换成class
            let cls = NSClassFromString(Bundle.main.namespace + "." + className) as? UIViewController.Type
        else {
                return UIViewController()
        }
        
        // 2. 创建视图控制器
        let vc = cls.init()
        vc.title = title
        
        // 设置TabBar图标
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        
        // 设置TabBar标题字体
        vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: RGBColor(51, 51, 51)], for: .highlighted)
        // 系统默认字体大小是12,若要修改字体大小,则需要在Normal状态下修改
        vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.5)], for: .normal)
        
        // 实例化导航控制器的时候,会调用push方法将rootVC压栈
        let nav = BWNavigationController(rootViewController: vc)
        return nav
    }
}

