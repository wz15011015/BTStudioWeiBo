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

//let BWWeiBoAppKey = "4240782545"
//let BWWeiBoAppSecret = "d29ee663d960989686a60e7291f3b5ee"

/// 回调地址 (授权登录完成后跳转的URL,参数以get形式拼接)
let BWWeiBoRedirectURI = "https://baidu.com"


// MARK: - 全局通知定义

/// 用户需要登录的通知
let BWUserShouldLoginNotification = "UserShouldLoginNotification"

/// 用户需要注册的通知
let BWUserShouldRegisterNotification = "UserShouldRegisterNotification"

/// 用户登录成功的通知
let BWUserLoginSuccessNotification = "UserLoginSuccessNotification"

/// 微博Cell浏览照片通知
let BWStatusCellBrowserPhotoNotification = "StatusCellBrowserPhotoNotification"
/// 选中索引 key
let BWStatusCellBrowserPhotoSelectedIndexKey = "StatusCellBrowserPhotoSelectedIndexKey"
/// 浏览照片URL字符串 key
let BWStatusCellBrowserPhotoURLsKey = "StatusCellBrowserPhotoURLsKey"
/// 父视图的图片视图数组 key
let BWStatusCellBrowserPhotoImageViewsKey = "StatusCellBrowserPhotoImageViewsKey"


// MARK: - 微博配图视图常量
/// 配图视图外侧间距
let WBStatusPictureViewOutterMargin = 12.0

/// 配图视图内部图片之间的间距
let WBStatusPictureViewInnerMargin = 3.0

/// 配图视图的宽度
let WBStatusPictureViewWidth = BW_Width - 2 * WBStatusPictureViewOutterMargin

/// 每个图片的默认宽度
let WBStatusPictureItemWidth = (WBStatusPictureViewWidth - 2 * WBStatusPictureViewInnerMargin) / 3
