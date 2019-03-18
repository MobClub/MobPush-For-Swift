//
//  CollectionViewCell.swift
//  MobPushDemoSwift
//
//  Created by LeeJay on 2019/1/22.
//  Copyright © 2019 YouZu. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setDatas(_ model : HomeModel) {
        
        titleLabel.text = model.title
        
        guard let imageNamed = model.imageNamed else { return }
        imageV.image = UIImage.init(named: imageNamed)
    }
}
