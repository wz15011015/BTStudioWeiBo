//
//  WeiBoConstant.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/10.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import Foundation


// MARK: - 应用程序信息

/// 应用程序ID
let BWWeiBoAppKey = "3404755718" // 4240782545   3404755718

/// 应用程序加密信息 (开发者可以申请修改)
let BWWeiBoAppSecret = "693aa985d05157269097e36a8c8b74d8" // d29ee663d960989686a60e7291f3b5ee   693aa985d05157269097e36a8c8b74d8

/// 回调地址 (授权登录完成后跳转的URL,参数以get形式拼接)
let BWWeiBoRedirectURI = "https://baidu.com"


// MARK: - 全局通知定义

/// 用户需要登录的通知
let BWUserShouldLoginNotification = "UserShouldLoginNotification"

/// 用户需要注册的通知
let BWUserShouldRegisterNotification = "UserShouldRegisterNotification"

/// 用户登录成功的通知
let BWUserLoginSuccessNotification = "UserLoginSuccessNotification"
