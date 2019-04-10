//
//  BWOAuthViewController.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/10.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

/// 通过WebView加载微博授权页面
class BWOAuthViewController: UIViewController {
    
    /// 授权页面WebView
    private lazy var webView = WKWebView()
    
    
    override func loadView() {
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false
        view = webView
        
        // 设置导航栏
        title = "登录新浪微博"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(dismissVC), isBack: true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoFill))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 加载授权页面
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(BWWeiBoAppKey)&redirect_uri=\(BWWeiBoRedirectURI)"
        guard let url = URL(string: urlString) else {
            return
        }
        // 创建请求
        let request = URLRequest(url: url)
        // 加载请求
        webView.load(request)
    }
    
    
    // MARK: - 监听方法
    @objc private func dismissVC() {
        SVProgressHUD.dismiss()
        
        dismiss(animated: true, completion: nil)
    }
    
    /// 自动填充
    ///
    /// webView的注入,直接通过js修改'本地浏览器'中缓存的页面内容
    /// 点击登录按钮,执行 submit() 将本地数据提交给服务器
    @objc private func autoFill() {
        // 准备js
        let js = "document.getElementById('userId').value = 'wz1310@sina.com';" + "document.getElementById('passwd').value = 'b24f5d113c';"
        // 让 webView 执行js
        webView.evaluateJavaScript(js) { (result, error) in
            if error != nil {
                print("webView执行js失败,error: \(error.debugDescription)")
            } else {
                print("webView执行js成功,result: \(result.debugDescription)")
            }
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

extension BWOAuthViewController: WKNavigationDelegate {
    
    /// 每当加载一个请求之前会调用该方法,通过该方法决定是否允许请求的发送
    ///
    /// - Parameters:
    ///   - webView: webView
    ///   - navigationAction: 导航动作对象
    ///   - decisionHandler: 处理回调 (决定是否允许请求的发送)
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // 1. 协议头 (http/https, 可以自定义协议头,可根据协议头判断是否要执行跳转)
        let scheme = navigationAction.request.url?.scheme ?? ""
        // 2. 主机名
        let hostName = navigationAction.request.url?.host?.lowercased() ?? ""
        // 3. 请求地址
        let urlString = navigationAction.request.url?.absoluteString ?? ""
        // 4. 查询字符串 (URL中 ? 后面的部分)
        let queryString = navigationAction.request.url?.query ?? ""
        
        print("hostName: \(hostName), scheme: \(scheme), urlString: \(urlString)")
        
        
        // 1. 如果请求地址包含 回调地址(https://baidu.com), 则不再加载页面;
        // 2. 从请求地址中查找是否含有"code=";
        // 3. 如果有,则从请求地址https://baidu.com/?code=xxxxxx中取出授权码;
        
        // 不包含回调地址,则继续加载;包含回调地址,则进行下一步的判断
        if !urlString.hasPrefix(BWWeiBoRedirectURI) {
            decisionHandler(.allow)
            return
        }
        // 回调地址中不包含code=,则表示用户点击了取消按钮,取消了授权,此时,dismiss该页面
        if !queryString.hasPrefix("code=") {
            decisionHandler(.cancel)
            dismissVC()
            return
        }
        decisionHandler(.cancel)
        
        // 回调地址中包含code=,则截取出授权码
        let startIndex = "xxxxx".endIndex
        let endIndex = queryString.endIndex
        let subIndex = startIndex..<endIndex
        let authCode = queryString[subIndex]
        print("authCode: \(authCode)")
        
        BWNetworkManager.shared.getAccessToken(authCode: String(authCode))
    }
    
    /// 每当接收到服务器返回的数据时会调用该方法,决定是否允许导航
    ///
    /// - Parameters:
    ///   - webView: webView
    ///   - navigationResponse: 响应结果
    ///   - decisionHandler: 处理回调 (决定是否允许导航)
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("WKWebView_收到服务器返回的数据")
        decisionHandler(.allow)
    }
    
    /// 当开始发送请求时调用
    ///
    /// - Parameters:
    ///   - webView: webView
    ///   - navigation: 导航对象
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("WKWebView_开始发送请求")
        SVProgressHUD.show()
    }
    
    /// 在收到服务器重定向时调用
    ///
    /// - Parameters:
    ///   - webView: webView
    ///   - navigation: 导航对象
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("WKWebView_收到服务器重定向")
    }
    
    /// 当开始发送请求时出现错误时调用
    ///
    /// - Parameters:
    ///   - webView: webView
    ///   - navigation: 导航对象
    ///   - error: 错误对象
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("WKWebView_开始发送请求时出现错误,error:\(error.localizedDescription)")
        SVProgressHUD.dismiss()
    }
    
    /// 当内容开始返回时调用
    ///
    /// - Parameters:
    ///   - webView: webView
    ///   - navigation: 导航对象
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("WKWebView_开始返回内容")
    }
    
    /// 当网页加载完毕时调用(该方法调用最频繁)
    ///
    /// - Parameters:
    ///   - webView: webView
    ///   - navigation: 导航对象
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WKWebView_加载完毕")
        SVProgressHUD.dismiss()
    }
    
    /// 当请求过程中出现错误时调用
    ///
    /// - Parameters:
    ///   - webView: webView
    ///   - navigation: 导航对象
    ///   - error: 错误对象
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("WKWebView_请求过程中出现错误,error:\(error.localizedDescription)")
    }
    
    /// 当收到服务器返回的受保护空间/证书时调用
    ///
    /// - Parameters:
    ///   - webView: webView
    ///   - challenge: 安全质询 (包含受保护空间和证书)
    ///   - completionHandler: 完成回调 (告诉服务器如何处置证书)
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // TODO: @escaping-逃逸闭包(https://www.jianshu.com/p/266c2370effd)
        
        // 创建凭据对象
        let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        // 告诉服务器信任证书
        completionHandler(.useCredential, credential)
    }
    
    /// 当WebView内容进程终止时调用
    ///
    /// - Parameter webView: webView
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("WKWebView_WebView内容进程终止.")
    }
    
}
