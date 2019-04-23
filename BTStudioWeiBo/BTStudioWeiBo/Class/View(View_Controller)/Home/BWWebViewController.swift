//
//  BWWebViewController.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/23.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit
import WebKit

/// Web页面
class BWWebViewController: BWBaseViewController {
    
    /// WebView的懒加载
    private lazy var webView = WKWebView(frame: self.view.bounds)
    
    /// URL地址
    var urlString: String?
    

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "微博正文"
        
        // 加载数据
        if let urlString = urlString, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    
    // MARK: - Override
    
    override func setupTableView() {
        // 添加webView
        webView.navigationDelegate = self
        view.insertSubview(webView, belowSubview: navigationBarCustom)
        webView.scrollView.contentInset.top = navigationBarCustom.bounds.height
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

extension BWWebViewController: WKNavigationDelegate {
    
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
//        let queryString = navigationAction.request.url?.query ?? ""
        
        print("hostName: \(hostName), scheme: \(scheme), urlString: \(urlString)")
        
        decisionHandler(.allow)
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
