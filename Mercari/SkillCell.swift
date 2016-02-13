//
//  SkillCell.swift
//  Mercari
//
//  Created by Varun Shenoy on 1/30/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit

class SkillCell: UICollectionViewCell {
    @IBOutlet weak var skillName: UILabel!
    @IBOutlet weak var skillImage: UIImageView!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
        
    }
    
    func configureCell(skill: String) {
        
        skillName.text = skill
        skillImage.image = UIImage(named: "\(skill.lowercaseString)")
    }

}
