//
//  AppDelegate.swift
//  MobPushDemoSwift
//
//  Created by LeeJay on 2019/1/21.
//  Copyright © 2019 YouZu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 设置推送环境
        #if DEBUG
            MobPush.setAPNsForProduction(false)
        #else
            MobPush.setAPNsForProduction(true)
        #endif
        
        //MobPush推送设置（获得角标、声音、弹框提醒权限）
        let configuration = MPushNotificationConfiguration()
        configuration.types = [.badge, .sound, .alert]
        MobPush.setupNotification(configuration)

        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.didReceiveMessage), name: NSNotification.Name.MobPushDidReceiveMessage, object: nil)
        
        return true
    }

    @objc func didReceiveMessage(noti: NSNotification) {
        guard let message = noti.object as? MPushMessage else {
            return
        }
        switch message.messageType {
        case .custom:
            showAlert(content: message.content)
        case .apns:
            print("收到远程通知", message.msgInfo)
        case .local:
            let body = message.notification.body
            let title = message.notification.title
            let subtitle = message.notification.subTitle
            let badge = message.notification.badge
            let sound = message.notification.sound
            print("收到本地通知body: \(String(describing: body)), title: \(String(describing: title)), subtitle: \(String(describing: subtitle)), badge: \(badge), sound: \(String(describing: sound))")
        case .clicked:
            if UIApplication.shared.applicationState == .active {
                showAlert(message: message)
            } else {
                pushVC(message: message)
            }
        default:
            break
        }
    }
    
    func showAlert(message: MPushMessage) {
        guard (message.msgInfo["url"] as? String) != nil else {
            return
        }
        
        let alert = UIAlertController.init(title: "收到推送", message: message.msgInfo.description, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let sureAction = UIAlertAction.init(title: "查看", style: .default) { (action) in
            self.pushVC(message: message)
        }
        alert.addAction(cancelAction)
        alert.addAction(sureAction)
        let vc = window?.rootViewController
        vc?.present(alert, animated: true, completion: nil)
    }
    
    func pushVC(message: MPushMessage) {
        guard let url = message.msgInfo["url"] as? String else {
            return
        }
        
        let nav = window?.rootViewController as! MOBNavigationViewController
        let webVC = WebViewController()
        webVC.url = url
        nav.pushViewController(webVC, animated: true)
    }
    
    func showAlert(content: String) {
        let alert = UIAlertController.init(title: "收到消息", message: content, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "我知道了", style: .default) { (action) in
            
        }
        alert.addAction(action)
        let vc = window?.rootViewController
        vc?.present(alert, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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

