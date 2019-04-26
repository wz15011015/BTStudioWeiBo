//
//  BWComposeViewController.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/19.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit
import SVProgressHUD

/**
 加载控制器的时候,如果 xib 和 控制器 同名,默认的构造函数会优先加载xib
 */

/// 撰写微博控制器
class BWComposeViewController: UIViewController {
    
    /// 文本视图
    @IBOutlet weak var textView: BWComposeTextView!
    
    /// 键盘的输入视图
    private lazy var emoticonInputView = BWEmoticonInputView.inputView { [weak self] (emoticon) in
        self?.textView.insertEmoticon(emoticon: emoticon)
    }
    
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
    
    /// 发布微博
    ///
    /// - Parameter sender: 发布按钮
    @IBAction func sendStatus(_ sender: UIButton) {
        print("发布微博的内容: \(textView.emoticonText)")
        return
        
        // 1. 获取微博内容文本
        let text = textView.emoticonText
        if text.count == 0 {
            return
        }
        let image = UIImage(named: "icon_earth")
        // 2. 发布微博
        BWNetworkManager.shared.postStatus(text: text, image: image) { (result, isSuccess) in
            print("发布微博: \(result)")
            // FIXME: 调试
//            let success = isSuccess
            let success = true
            
            let message = success ? "发布成功" : "网络不给力"
            // 修改指示器样式
            SVProgressHUD.setDefaultStyle(.dark)
            
            SVProgressHUD.showInfo(withStatus: message)
            if success {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    // 恢复指示器样式
                    SVProgressHUD.setDefaultStyle(.light)
                    
                    self.dismissVC()
                })
            }
        }
    }
    
    /// 切换表情键盘
    @objc func emoticonKeyboard() {
        /**
         textView.inputView就是文本框的输入视图
         如果使用系统默认的键盘,输入视图为nil
         */
//        let keyboard = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 346))
//        keyboard.backgroundColor = UIColor.orange
        
        // 设置输入视图
        /**
         * - 如果为空,表示当前为系统键盘,则设置为自定义键盘;
         * - 如果不为空,表示当前为自定义键盘,则设置为nil,切换至系统键盘;
         */
        textView.inputView = (textView.inputView == nil) ? emoticonInputView : nil
        
        // 设置输入助理视图 (键盘消失,助理视图随之消失!)
//        textView.inputAccessoryView = toolBar
        
        // 刷新输入视图 (切换键盘注意必须刷新输入视图)
        textView.reloadInputViews()
    }
    
    @objc func addOther() {
        textView.inputView = nil
        textView.reloadInputViews()
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
private extension BWComposeViewController {
    
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
        let toolbarItemsInfo = [["imageName": "compose_toolbar_picture", "actionName": "addOther"],
                                ["imageName": "compose_mentionbutton_background", "actionName": "addOther"],
                                ["imageName": "compose_trendbutton_background", "actionName": "addOther"],
                                ["imageName": "compose_emoticonbutton_background", "actionName": "emoticonKeyboard"],
                                ["imageName": "compose_add_background", "actionName": "addOther"]]
        
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
            
            // 添加监听事件
            if let actionName = info["actionName"] {
                button.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }
            
            toolbarButtons.append(UIBarButtonItem(customView: button))
            // 追加弹簧
            toolbarButtons.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        // 删除最后一个弹簧
        toolbarButtons.removeLast()
        
        toolBar.items = toolbarButtons
    }
}
