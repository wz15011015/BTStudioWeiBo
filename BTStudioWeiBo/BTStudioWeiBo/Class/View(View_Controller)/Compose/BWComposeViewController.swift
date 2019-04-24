//
//  BWComposeViewController.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/19.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/**
 加载控制器的时候,如果 xib 和 控制器 同名,默认的构造函数会优先加载xib
 */

/// 撰写微博控制器
class BWComposeViewController: UIViewController {
    
    /// 文本视图
    @IBOutlet weak var textView: BWComposeTextView!
    
    /// 底部工具栏
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var toolBarBottom: NSLayoutConstraint!
    
    /// 发布按钮
    @IBOutlet var sendButton: UIButton!
    
    /// 标题View (换行的热键: option + enter)
    @IBOutlet var titleLabel: UILabel!
    

    // MARK: - Life Cycle
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 弹出键盘
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 收起键盘
        view.endEditing(true)
    }
    
    
    // MARK: - 监听方法
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendStatus(_ sender: UIButton) {
        print("发布微博")
    }
    
    // MARK: - 键盘通知
    @objc func keyboardWillChangeFrame(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let rect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
                return
        }
       
        // 更新toolBar的底部约束
        if Is_iPhone_X_Series {
            if rect.height < 100 { // 收起键盘
                toolBarBottom.constant = 0
            } else { // 弹出键盘
                toolBarBottom.constant = rect.height - CGFloat(TabBarAddedHeight())
            }
        } else {
            toolBarBottom.constant = rect.height
        }
        
        // 更新约束
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
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


// MARK: - UITextViewDelegate

extension BWComposeViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        // 根据是否有文本输入,来确定发布按钮的禁用状态
        sendButton.isEnabled = textView.hasText
    }
}


// MARK: - 设置界面
extension BWComposeViewController {
    
    func setupUI() {
        title = "发微博"
        view.backgroundColor = UIColor.white
        
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: UIWindow.keyboardWillChangeFrameNotification, object: nil)
        
        setupNavigationBar()
        setupToolBar()
    }
    
    /// 设置导航栏
    func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
        navigationItem.titleView = titleLabel
        
        // 初始时,禁用发布按钮
        sendButton.isEnabled = false
    }
    
    /// 设置工具栏
    func setupToolBar() {
        let toolbarItemsInfo = [["imageName": "compose_toolbar_picture"],
                                ["imageName": "compose_mentionbutton_background"],
                                ["imageName": "compose_trendbutton_background"],
                                ["imageName": "compose_emoticonbutton_background"],
                                ["imageName": "compose_add_background"]]
        
        var toolbarButtons: [UIBarButtonItem] = []
        for info in toolbarItemsInfo {
            guard let imageName = info["imageName"] else {
                continue
            }
            let image = UIImage(named: imageName)
            let imageHighlighted = UIImage(named: imageName + "_highlighted")
            
            let button = UIButton()
            button.setImage(image, for: .normal)
            button.setImage(imageHighlighted, for: .highlighted)
            button.sizeToFit()
            
            toolbarButtons.append(UIBarButtonItem(customView: button))
            // 追加弹簧
            toolbarButtons.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        // 删除最后一个弹簧
        toolbarButtons.removeLast()
        
        toolBar.items = toolbarButtons
    }
}
