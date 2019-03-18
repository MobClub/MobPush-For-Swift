//
//  ViewController.swift
//  MobPushDemoSwift
//
//  Created by LeeJay on 2019/1/21.
//  Copyright © 2019 YouZu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    override class func mobPushPath() -> String {
        return "/path/ViewController"
    }
    
    convenience init(mobPushScene params: [AnyHashable: Any]?) {
        self.init()
    }
    
    fileprivate lazy var flowlayout : UICollectionViewFlowLayout = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical
        flowlayout.minimumLineSpacing = 30
        flowlayout.minimumInteritemSpacing = 30
        flowlayout.itemSize = CGSize(width: (ScreenWidth - 90) / 2, height: ((ScreenWidth - 90) / 2 * 7) / 5)
        return flowlayout
    }()
    
    fileprivate lazy var collectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.init(x: 30, y: 0 , width: ScreenWidth - 60, height: ScreenHeight), collectionViewLayout: self.flowlayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(UINib.init(nibName:"CollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: kCollectionViewCell)
        collectionView.register(UINib.init(nibName:"CollectionHeaderView", bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kCollectionHeaderView)
        return collectionView
    }()
    
    fileprivate lazy var datas = [HomeModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.white
        title = "MobPushDemo"
        
        for i in 0...5 {
            
            let model = HomeModel()
            
            switch i {
            case 0:
                model.imageNamed = "local"
                model.title = "App内推送"
            case 1:
                model.imageNamed = "remote"
                model.title = "通知"
            case 2:
                model.imageNamed = "schedule"
                model.title = "定时通知"
            case 3:
                model.imageNamed = "localNotication"
                model.title = "本地通知"
            case 4:
                model.imageNamed = "pushVC"
                model.title = "推送打开指定链接页面"
            case 5:
                model.imageNamed = "linkitem"
                model.title = "推送打开应用内指定页面"
            default:
                break
            }
            
            datas.append(model)
        }
        
        view.addSubview(collectionView)
    }
}
//MARK: - CollectionView DataSource Delegate
extension ViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCollectionViewCell, for: indexPath) as! CollectionViewCell
        let model = datas[indexPath.row]
        cell.setDatas(model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reuseIdentifier : String?
        if kind == UICollectionView.elementKindSectionHeader {
            reuseIdentifier = kCollectionHeaderView
        }
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifier!, for: indexPath)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: ScreenWidth, height: 76)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PushDetailViewController(type: DetailType(rawValue: indexPath.row)!)
        navigationController?.pushViewController(vc, animated: true)
    }
}

