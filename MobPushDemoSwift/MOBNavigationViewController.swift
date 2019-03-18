//
//  MOBNavigationViewController.swift
//  MobPushDemoSwift
//
//  Created by LeeJay on 2019/1/24.
//  Copyright © 2019 YouZu. All rights reserved.
//

import UIKit

class MOBNavigationViewController: UINavigationController, UIGestureRecognizerDelegate {

    var enablePopGesture: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        interactivePopGestureRecognizer?.delegate = self
        navigationBar.tintColor = UIColor.black
    }
    
    @objc func navGoBack() {
        popViewController(animated: true)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard viewControllers.count > 1 else {
            return false
        }
        return enablePopGesture
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count >= 1 {
            viewController.hidesBottomBarWhenPushed = true;
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "return"), style: .plain, target: self, action: #selector(MOBNavigationViewController.navGoBack))
        }
        super.pushViewController(viewController, animated: animated)
    }
}
