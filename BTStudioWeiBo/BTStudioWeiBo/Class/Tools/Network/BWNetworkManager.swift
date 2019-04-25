//
//  BWNetworkManager.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/8.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit
import AFNetworking


// Swift 枚举支持任意数据类型
/// 请求方式
///
/// - GET: GET请求
/// - POST: POST请求
enum BWHTTPMethod {
    case GET
    case POST
}


/// 网络管理工具
class BWNetworkManager: AFHTTPSessionManager {
    
    /// 单例: 静态区 常量 闭包
    /// 在第一次访问时,执行闭包,并且将结果保存在 shared 常量中
//    static let shared = BWNetworkManager()
    static let shared: BWNetworkManager = {
        // 实例化对象
        let instance = BWNetworkManager()
        // 设置响应反序列化支持的数据类型
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        // 返回对象
        return instance
    }()
    
    /// 用户账户
    lazy var userAccount = BWUserAccount()
    
    /// 访问令牌,所有网络请求都基于此令牌(登录接口除外)
    ///
    /// 为了保护用户安全,token都是有时限的,默认是三天
//    var accessToken: String? // 2.00UfZikCTQtzcE9e3084d975yflGtC  2.00UfZikCoUA7iDf2256d15920LHE8j
    
    /// 用户微博ID
//    var uid: String? = "5365823342"
    
    /// 用户登录标记 (计算型属性)
    var userLogon: Bool {
        return userAccount.access_token != nil
    }
    
    
    /// 专门负责带token的网络请求
    ///
    /// - Parameters:
    ///   - method: 请求类型 (GET / POST)
    ///   - URLString: 请求地址
    ///   - parameters: 入参字典
    ///   - name: 接收上传数据的服务器字段,默认为nil,不上传文件
    ///   - data: 要上传的二进制数据,默认为nil,不上传文件
    ///   - completion: 完成回调 (json: 结果, isSuccess: 是否成功)
    func tokenRequest(method: BWHTTPMethod = .GET, URLString: String, parameters: [String: Any]?, name: String? = nil, data: Data? = nil, completion: @escaping (_ json: Any?, _ isSuccess: Bool) -> ()) {
        // 拼接token
        // 1. 判断token是否为空
        guard let token = userAccount.access_token else {
            print("没有token,需要登录")
            // 发送通知,提示用户去登录
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: BWUserShouldLoginNotification), object: "none access_token")
            
            completion(nil, false)
            return
        }
        // 2. 判断入参是否为空,如果为空,需要新建一个字典
        var tempParameters: [String: Any] = [: ]
        if parameters != nil {
            tempParameters = parameters!
        }
        tempParameters["access_token"] = token
        
        // 3. 判断name和data, 如果都有值,则为上传文件
        if let name = name, let data = data {
            upload(URLString: URLString, parameters: tempParameters, name: name, data: data, completion: completion)
        } else {
            request(method: method, URLString: URLString, parameters: tempParameters, completion: completion)
        }
    }
    
    /// 封装AFNetworking的 GET / POST 请求
    ///
    /// 使用一个函数封装 GET / POST 请求
    ///
    /// - Parameters:
    ///   - method: 请求类型 (GET / POST)
    ///   - URLString: 请求地址
    ///   - parameters: 入参字典
    ///   - completion: 完成回调 (json: 结果, isSuccess: 是否成功)
    func request(method: BWHTTPMethod = .GET, URLString: String, parameters:[String: Any], completion: @escaping (_ json: Any?, _ isSuccess: Bool) -> ()) {
        
        /// 成功回调
        let success = { (task: URLSessionDataTask, json: Any?) -> () in
            completion(json, true)
        }
        
        /// 失败回调
        let failure = { (task: URLSessionDataTask?, error: Error) -> () in
            print("网络请求错误, error: \(error)")
            let response = task?.response as? HTTPURLResponse
            let statusCode = response?.statusCode ?? -1
            if statusCode == 403 {
                print("token已过期!")
                // 发送通知,提示用户重新登录
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: BWUserShouldLoginNotification), object: "bad access_token")
            }
            completion(nil, false)
        }
        
        if method == .GET {
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        } else {
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
    
    /// 封装AFNetworking的上传文件方法
    ///
    /// - Parameters:
    ///   - URLString: 请求地址
    ///   - parameters: 入参字典
    ///   - name: 接收上传数据的服务器字段(需要咨询公司的后台,'pic')
    ///   - data: 要上传的二进制数据
    ///   - completion: 完成回调 (json: 结果, isSuccess: 是否成功)
    func upload(URLString: String, parameters: [String: Any]?, name: String, data: Data, completion: @escaping (_ json: Any?, _ isSuccess: Bool) -> ()) {
        post(URLString, parameters: parameters, constructingBodyWith: { (formData) in
            /**
             * 1. data: 要上传的二进制数据
             * 2. name: 服务器接收数据的字段名
             * 3. fileName: 保存在服务器的文件名,大多服务器可以乱写,
             *    很多服务器在上传图片后,会生成缩略图/中图/大图等
             * 4. mimeType: 告诉服务器上传文件的类型,如果不想告诉,可以使用:application/octet-stream
             *    image/png  image/jpg  image/gif
             */
            formData.appendPart(withFileData: data, name: name, fileName: "imageName", mimeType: "application/octet-stream")
        }, progress: { (_) in
            
        }, success: { (_, json) in
            completion(json, true)
        }) { (task, error) in
            let response = task?.response as? HTTPURLResponse
            let statusCode = response?.statusCode ?? -1
            if statusCode == 403 {
                print("token已过期!")
                // 发送通知,提示用户重新登录
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: BWUserShouldLoginNotification), object: "bad access_token")
            }
            completion(nil, false)
        }
    }
}
