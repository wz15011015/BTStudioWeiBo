//
//  AppDelegate.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/3/30.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound, .carPlay]) { (success, error) in
                print("App通知授权 " + (success ? "成功" : "失败") + " !")
            }
        } else {
            // 获得用户授权显示通知(弹窗/图标/声音)
            let notifySettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(notifySettings)
        }
        
        
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        
        window?.rootViewController = BWMainViewController()
        
        window?.makeKeyAndVisible()
        
        loadAppInfo()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


// MARK: - 从服务器加载应用程序信息
extension AppDelegate {
    
    private func loadAppInfo() {
        // 1. 模拟异步
        DispatchQueue.global().sync {
            let path = Bundle.main.path(forResource: "Main", ofType: "json")
            let data = NSData(contentsOfFile: path ?? "")
            
            // 写入磁盘
            let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let jsonPath = docDir.appendingFormat("/%@", "Main.json")
//            let jsonPath2 = (docDir as NSString).appendingPathComponent("Main.json")
            print("jsonPath: \(jsonPath)")
            
            // 直接保存在沙盒,等待下一次程序启动时使用
            data?.write(toFile: jsonPath, atomically: true)
        }
    }
}

