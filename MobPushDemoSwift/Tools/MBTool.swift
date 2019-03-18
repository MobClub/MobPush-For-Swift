//
//  MBTool.swift
//  MobPushDemoSwift
//
//  Created by LeeJay on 2019/1/24.
//  Copyright © 2019 YouZu. All rights reserved.
//

import MBProgressHUD

extension MBProgressHUD {

    func showTitle(_ title: String, view: UIView) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text
        hud.backgroundView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        hud.bezelView.backgroundColor = UIColor.white;
        hud.detailsLabel.textColor = UIColor.black;
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 14);
        hud.detailsLabel.text = title;
        hud.hide(animated: true, afterDelay: 1.5)
        return hud
    }
    
}
