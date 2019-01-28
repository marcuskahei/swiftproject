//
//  PageCell.swift
//  autolayout_lbta
//
//  Created by marcus.man on 22/1/2019.
//  Copyright © 2019 Lets Build That App. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.backgroundColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
