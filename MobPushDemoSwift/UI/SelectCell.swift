//
//  SelectCell.swift
//  MobPushDemoSwift
//
//  Created by LeeJay on 2019/1/23.
//  Copyright © 2019 YouZu. All rights reserved.
//

import UIKit

class SelectCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    
    var btnSelected: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imageV.isHidden = !btnSelected
    }

    func setModel(_ model: SelectModel) {
        
        titleLabel.text = model.title
        titleLabel.textColor = model.selected ? model.selectedColor : UIColor.black
        imageV.isHidden = !model.selected
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
