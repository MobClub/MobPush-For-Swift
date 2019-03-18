//
//  PushDetailViewController.swift
//  MobPushDemoSwift
//
//  Created by LeeJay on 2019/1/22.
//  Copyright © 2019 YouZu. All rights reserved.
//

import UIKit
import MBProgressHUD

enum DetailType: Int {
    case inApp = 0, remoteNoti, scheduleNoti, localNoti, urlPage, anyPage
}

class PushDetailViewController: UIViewController {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var customView: CustomView!
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    var type: DetailType = .inApp
    var datas: [SelectModel]?
    
    override class func mobPushPath() -> String {
        return "/path/PushDetailViewController"
    }
    
    convenience init(mobPushScene params: [AnyHashable: Any]?) {
        self.init()

        guard let dict = params,
            let type = dict["type"] else {
                return
        }
        self.type = DetailType(rawValue: type as! Int)!
    }
    
    convenience init(type: DetailType) {
        self.init()
        self.type = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        customView.callBack = {(datas) in
            self.datas = datas
        }
        customView.setType(type)

        switch type {
        case .inApp:
            title = "App内推送"
            descLabel.text = "点击测试按钮后，你将立即收到一条app内推送"
            sendBtn.backgroundColor = MOBFColor.color(withRGB: 0x7B91FF)
            heightConst.constant = 100
        case .remoteNoti:
            title = "通知"
            descLabel.text = "点击测试按钮后，5s左右将收到一条测试通知"
            sendBtn.backgroundColor = MOBFColor.color(withRGB: 0xFF7D00)
            heightConst.constant = 100
        case .scheduleNoti:
            title = "定时通知"
            descLabel.text = "设置时间后点击测试按钮，在到设置时间时将收到一条测试通知"
            sendBtn.backgroundColor = MOBFColor.color(withRGB: 0x29C18B)
            heightConst.constant = 260
        case .localNoti:
            title = "本地通知"
            descLabel.text = "设置时间后点击测试按钮，在到设置时间时将收到一条测试通知"
            sendBtn.backgroundColor = MOBFColor.color(withRGB: 0xFF7D00)
            heightConst.constant = 260
        case .urlPage:
            title = "推送打开指定链接页面"
            descLabel.text = "编辑完成后，点击测试按钮后，你将立即收到一条推送消息，点击后可跳转至指定页面。"
            sendBtn.backgroundColor = MOBFColor.color(withRGB: 0x7B91FF)
            heightConst.constant = 220
        case .anyPage:
            title = "推送打开应用内指定页面"
            descLabel.text = "编辑完成后，点击测试按钮后，你将立即收到一条推送消息，点击后可跳转至指定的应用内页面。"
            sendBtn.backgroundColor = MOBFColor.color(withRGB: 0x00D098)
            heightConst.constant = 230
        }
    }
    
    @IBAction func onSelect(_ sender: Any) {
        
        guard let text = customView.textView.text else {
            showMessage(title: "请填写推送内容")
            return
        }
        
        guard text != "" else {
            showMessage(title: "请填写推送内容")
            return
        }
        
        switch type {
        case .inApp: // 应用内
            
            sendMessage(type: .custom, text: text, space: 0, extras: nil, linkScheme: nil, linkData: nil)
            
        case .remoteNoti: // 远程通知
            
            sendMessage(type: .apns, text: text, space: 0, extras: nil, linkScheme: nil, linkData: nil)
            
        case .scheduleNoti: // 定时远程通知
            
            var time = 0
            guard let dataModels = datas else {
                return
            }
            
            for i in 0..<dataModels.count {
                
                let model = dataModels[i]
                
                if model.selected {
                    time = i + 1
                    break;
                }
            }
            
            sendMessage(type: .apns, text: text, space: NSNumber.init(value:time), extras: nil, linkScheme: nil, linkData: nil)
            
        case .localNoti: // 定时本地通知
            
            var isInstant = true
            var time = 0
            guard let dataModels = datas else {
                return
            }
 
            for i in 0..<dataModels.count {
                
                let model = dataModels[i]
                
                if model.selected {
                    isInstant = false
                    time = i + 1
                    break
                }
            }
            
            // 创建本地通知
            let message = MPushMessage()
            message.messageType = .local
            let noti = MPushNotification()
            noti.body = text
            noti.title = "标题"
            noti.subTitle = "子标题"
            noti.sound = "unbelievable.caf"
            noti.badge = UIApplication.shared.applicationIconBadgeNumber < 0 ? 0 : UIApplication.shared.applicationIconBadgeNumber + 1
            message.notification = noti;
            
            if isInstant { // 设置立即发送本地推送
                message.isInstantMessage = true
            } else { // 设置几分钟后发起本地推送
                let currentDate = Date.init(timeIntervalSinceNow: 0)
                let nowtime = currentDate.timeIntervalSince1970 * 1000
                let taskDate = nowtime + Double(time * 60 * 1000)
                message.taskDate = taskDate;
            }
            
            MobPush.addLocalNotification(message)
            
        case .urlPage: // 跳转指定网页
            
            var urlStr = "http://m.mob.com"
            if customView.textField.text != nil && customView.textField.text != "" {
                urlStr = customView.textField.text!
            }
            
            if !urlStr.hasPrefix("http://") && !urlStr.hasPrefix("https://") {
                urlStr = "http://" + urlStr
            }
            
            sendMessage(type: .apns, text: text, space: 0, extras: ["url": urlStr], linkScheme: nil, linkData: nil)
            
        case .anyPage: // 跳转任意页面
            
            var linkScheme = ""
            var params: [String: Any]?
            
            guard let dataModels = datas else {
                return
            }
            
            for i in 0..<dataModels.count {
                
                let model = dataModels[i]
                
                if model.selected {
                    if i == 0 {
                        linkScheme = "/path/ViewController"
                        params = nil
                    } else if i == 1 {
                        linkScheme = "/path/PushDetailViewController"
                        params = ["type": 0]
                    } else if i == 2 {
                        linkScheme = "/path/PushDetailViewController"
                        params = ["type": 1]
                    } else if i == 3 {
                        linkScheme = "/path/PushDetailViewController"
                        params = ["type": 2]
                    }
                    
                    break
                }
            }
            
            sendMessage(type: .apns, text: text, space: 0, extras: nil, linkScheme: linkScheme, linkData: MOBFJson.jsonString(from: params))

        }
    }
    
    // 发送消息
    func sendMessage(type: MSendMessageType, text: String, space: NSNumber, extras: [AnyHashable: Any]!, linkScheme: String!, linkData: String!) {
        
        var isPro = true
        
        #if DEBUG
        isPro = false
        #endif
        
        MBProgressHUD.showAdded(to: view, animated: true)
        MobPush.sendMessage(with: type, content: text, space: space, isProductionEnvironment: isPro, extras: extras, linkScheme: linkScheme, linkData: linkData) { (error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error == nil {
                self.showMessage(title: "发送成功")
            } else {
                self.showMessage(title: "发送失败")
            }
        }
    }
    
    func showMessage(title: String) {
        let hud = MBProgressHUD.showAdded(to: navigationController!.view, animated: true)
        hud.mode = .text
        hud.backgroundView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        hud.bezelView.backgroundColor = UIColor.white;
        hud.detailsLabel.textColor = UIColor.black;
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 14);
        hud.detailsLabel.text = title;
        hud.hide(animated: true, afterDelay: 1.5)
    }
}
