//
//  CustomView.swift
//  MobPushDemoSwift
//
//  Created by LeeJay on 2019/1/23.
//  Copyright © 2019 YouZu. All rights reserved.
//

import UIKit

class CustomView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var textView: IQTextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var otherHeightConst: NSLayoutConstraint!
    @IBOutlet weak var tableHeightConst: NSLayoutConstraint!
    fileprivate var type: DetailType = .inApp
    
    fileprivate lazy var datas = [SelectModel]()
    
    var callBack : ((_ datas: [SelectModel]?) -> Void)?
    
    func setType(_ type : DetailType) {

        self.type = type

        createModels(type: type)
        
        switch type {
        case .inApp:
            tableView.isHidden = true
            otherView.isHidden = true
            otherHeightConst.constant = 0
            tableHeightConst.constant = 0
        case .remoteNoti:
            tableView.isHidden = true
            otherView.isHidden = true
            otherHeightConst.constant = 0
            tableHeightConst.constant = 0
        case .scheduleNoti:
            otherView.isHidden = true
            otherHeightConst.constant = 0
            tableHeightConst.constant = 150
        case .localNoti:
            otherView.isHidden = true
            otherHeightConst.constant = 0
            tableHeightConst.constant = 150
        case .urlPage:
            tableView.isHidden = true
            otherHeightConst.constant = 120
            tableHeightConst.constant = 0
        case .anyPage:
            otherView.isHidden = true
            otherHeightConst.constant = 0
            tableHeightConst.constant = 120
        }
    }
    
    func createModels(type: DetailType) {
        
        switch type {
        case .scheduleNoti:
            for i in 0..<5 {
                let model = SelectModel()
                model.title = String(i+1) + "分钟"
                model.selectedColor = MOBFColor.color(withRGB: 0x29C18B)
                datas.append(model)
            }
        case .localNoti:
            for i in 0..<5 {
                let model = SelectModel()
                model.title = String(i+1) + "分钟"
                model.selectedColor = MOBFColor.color(withRGB: 0xFF7D00)
                datas.append(model)
            }
        case .anyPage:
            for i in 0..<4 {
                let model = SelectModel()
                switch i {
                case 0:
                    model.title = "首页"
                    model.selected = true
                case 1:
                    model.title = "App内推送测试页面"
                case 2:
                    model.title = "通知测试页面"
                case 3:
                    model.title = "定时通知测试页面"
                default:
                    break
                }
                model.selectedColor = MOBFColor.color(withRGB: 0x29C18B)
                datas.append(model)
            }
        default:
            break
        }
        
        if callBack != nil {
            callBack!(datas)
        }
        
        tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let view = Bundle.main.loadNibNamed("CustomView", owner: self, options: nil)?.first
        guard let contentView = view as? UIView else {
            return
        }
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.tableFooterView = UIView()
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = MOBFColor.color(withRGB: 0xE6E6EC)?.cgColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "SelectCell", bundle: nil), forCellReuseIdentifier: kSelectCell)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kSelectCell, for: indexPath) as! SelectCell
        cell.setModel(datas[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for model in datas {
            if model.selected {
                model.selected = false
            }
        }
        let model = datas[indexPath.row]
        model.selected = true
    
        if callBack != nil {
            callBack!(datas)
        }
        
        tableView.reloadData()
    }
}
